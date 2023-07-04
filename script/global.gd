extends Node
@onready var root = get_tree().get_root()

const DropSpeed = 20 
const NormalAOERangeY = 20
const SkillAOERangeY = 500

const VILLAGE = 1
const MONSTER = -1
const MIDDLE = 0
#MONSTER,ALL,VILLAGE
const LAyer = [[2,8,32],[1+2+16+32],[1,4,16]]
#碰撞层：敌方普通，敌方海,敌方基地,敌友全部除海,全部，我方普通，我方海，我方基地
const MAsk = [[1+16,1+4+16,16,1+4],[1+2+16+32],[2+32,2+8+32,32,2+8]]
#const deathLayer = 32
enum AttackType {NEAR,FAR,EXPLODE}
const AddDamage = 1.5
enum Effect {ATTDAMAGE,ATTRANGE,SPEED,FREEZE,HOLDAMAGE,DAMAGE,KNOCK}
const EffGood = Effect.DAMAGE
enum DamValue {HOLDAMAGE,DAMAGE,KNOCK}
const EffValue = [0.5,0.5,0.5,0]
const EFFGOOD = 1
const OFFEFFECT = 0
const EFFBAD = -1
#			print(aoeModel)
#			print(aoeRange)
#			print(ifAoeHold)
#			print(attackType)
#			print(damage)
#			print(damagerType)
#			print(giveEffect)
#			print(effValue)
#			print(effTime)
#			print(effTimes)
#const ProDire = {"arrow":Vector2(1,0),"arrowUp":Vector2(1,-1),"tnt":Vector2(0,1),
#"fireBall":Vector2(1,0),"fireBallDown":Vector2(1,1),"water":Vector2(1,0),"snowBall":Vector2(1,0)}
#const ProPicture = {"arrow":1,"arrowUp":1,"tnt":1,"fireBall":1,"fireBallDown":1,"water":1,"snowBall":1
#}
#const ProAniTime = {"arrow":0,"arrowUp":0,"tnt":0,"fireBall":0,"fireBallDown":0,"water":0,"snowBall":0
#}
var calu = preload("res://script/fight/calu/attackCalu.gd")
enum damCaluType {ATTEFF,EFF}
const TRANSFER = null
enum IfAoeType {IN,OUT,NONE}
const SkillHold = -1
func damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):
	var newCalu = calu.new()
	var target = newCalu
	if type == TRANSFER: target = damager
	target.attackType = attackType
	target.damage = damage
	target.damagerType = damagerType
	target.giveEffect = giveEffect
	target.effValue = effValue
	target.effTime = effTime
	target.effTimes = effTimes
	if type != TRANSFER&&damager!=null:
		match type:
			damCaluType.ATTEFF: newCalu.normalAttackCalu(damager)
			damCaluType.EFF: newCalu.effectAttackCalu(damager)
	else: newCalu.free()
	pass
	
var aoe = preload("res://sence/fight/calu/aoe.tscn")
const CREATE = 0
enum AoeSet {ATTACK,NORMAL,DEATH}
func aoe_create(damager,type,aoeModel,aoeRange,ifAoeHold,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):
	var newAoe = aoe.instantiate()
	var target = newAoe
	if type == TRANSFER: target = damager
	target.aoeModel = aoeModel
	target.aoeRange = aoeRange
	target.ifAoeHold = ifAoeHold
	target.attackType = attackType
	target.damage = damage
	target.damagerType = damagerType
	target.giveEffect = giveEffect
	target.effValue = effValue
	target.effTime = effTime
	target.effTimes = effTimes
	if type != TRANSFER&&damager!=null:
		root.call_deferred("add_child",newAoe)
		newAoe.position = damager.global_position
		#newAoe.position.y = FightGroundY
	else: newAoe.free()
	#return newAoe
	pass

var LevelChoiceButton
var LevelChoiceWindow
var BuyCardButton
var BuyCardWindow
var BookWindow

var MiniGame = 2#0
var MiniGameWindow
var MiniGameSence
var MiniGameScore
var MiniGame2PosY:Array

var ChangePageButton
var ShowLastId
var ShowPicture
var ShowName
var ShowDisplay
var ShowText
var PageNow = true#
const Page = {true:"allVillageObject",false:"allMonsterObject"}
#{"allVillageObject":true,"allMonsterObject":false}

var LevelReady = false

var ChosenCardNum = 0
var ChoiceWindow
var FightButton
var ChosenCard = [null,null,null,null,null,null]
var ChosenId = [null,null,null,null,null,null]
var NowMonsterObject = []
var StopButton
var StopWindowLayer
var StopWindow
var StopON = false

var FightSence
var FightGroundY
var FightSkyY
var VillagePoint
var MonsterPoint
var BossStopX
var BossPosX
var BossProtect
var BossSkill
var VillageBase
#var VillageBaseOpen = load("res://assets/objects/baseVillage2.png")
#var VillageBaseClose = load("res://assets/objects/baseVillage1.png")
var MonsterBase
var towerArea
var skillArea
var Boss

var SoldierOutLine = preload("res://rescourse/soldierOutLine.tres")
var ButtonOutLine = preload("res://rescourse/buttonOutLine.tres")
var CardOutLine = preload("res://rescourse/cardOutLine.tres")
var VillageSoldier = preload("res://sence/fight/object/soldier/villageSoldier.tscn")
var MonsterSoldier = preload("res://sence/fight/object/soldier/monsterSoldier.tscn")
var Soldier = preload("res://sence/fight/object/soldier.tscn")
var Tower = preload("res://sence/fight/object/tower.tscn")
var Skill = preload("res://sence/fight/object/skill.tscn")

var ParSence:Dictionary
#= preload("res://sence/particles/hurtRed.tscn")
var Point #= 0
var Brought #= {"freeze":false,"wall":false,"power":false,"golder":false}

var STSData:Dictionary
enum STSType {INT,ARRAY}
const STSDataName = {"price":STSType.INT,"kind":null,
"coll2Pos":null,"health":STSType.INT,"type":null,"towKeepTime":STSType.INT,"soldierName":null,
"animation":null,"aniSpeedBasic":null,"speedBasic":null,"ifOnlyAttBase":null,
"attackType":null,"damageMethod":null,"damagerType":null,"damageBasic":null,"projectile":null,
"proSpeed":null,"ifPriece":null,"attRangeBasic":null,"proSleepTime":STSType.INT,"proContinueTimes":STSType.INT,"aoeModel":null,"aoeRange":null,"ifAoeHold":null,
"effValue":null,"effTime":null,"effTimes":null,"effDefence":null,"giveEffect":null,"usualTime":null,
"endTime":null,"time":null,"ifHealthEffect":null,"healthEffValue":STSType.INT,"ifDistanceEffect":null,"attDefOrigin":null,"shield":STSType.INT,
"attDefShield":null,"satDefValue":STSType.INT,"attDefState":null}

var SeDB = 1.0
var BgmDB = 1.0
var ThunderSpeed
var CaveHas = false
var MonsterDeaths = 0
var Money = 10
var CardUp = 6
var NowMoney = 0

var CardBuy = null
var Contrl = null

var LevelData
var Level = 1
var NowLevel = 1
enum  LevelType {ATTACK,ATTDEF,DEFENCE}
var LevelOver = false
var TextData

func _ready():#读入数据
#	var json = JSON.new()
#	var loadData = FileAccess.open("user://playerData.json",FileAccess.READ)
#	var waitJson = loadData.get_as_text()
#	json.parse(waitJson)
#
#	Point = json.data["Point"]
#	Brought = json.data["Brought"]
#	Level = json.data["Level"]
#	loadData = null
#	root.close_requested.connect(closeWindow)
	
#	if Brought["card"] == 1: CardUp = 5
#	if Brought["card"] == 2: CardUp = 6
#	if Brought["gold"] == 1: Money = 20
#	if Brought["gold"] == 2: Money = 30
#	Money = 10
#	CardUp = 6

	var file = FileAccess.open("res://data/object.json", FileAccess.READ)#user:
	var content = file.get_as_text()#读取所有士兵数据
	var jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.STSData = jsonValue.data
	#var arrayLength

	for STSName in jsonValue.data:#把所有数值变成int,数组要挨个把里面的值重新读
#		for STSDatename in STSData[STSName]:
#			if STSDataName.has(STSDatename):
#				match STSDataName[STSDatename]:
#					STSType.INT: 
#						STSData[STSName][STSDatename] = int(jsonValue.data[STSName][STSDatename])
#					Global.STSType.ARRAY: 
#						arrayLength = Global.STSData[STSName][STSDatename].size()
#						for i in arrayLength:
#							Global.STSData[STSName][STSDatename][i] = int(jsonValue.data[STSName][STSDatename][i])
		
		var pictureGet#提前根据图片得到单位碰撞箱尺寸

		match STSData[STSName]["type"]:
			"soldier": pictureGet = load("res://assets/objects/soldier/%s/walk/walk1.png"% STSName)
			"tower": pictureGet = load("res://assets/objects/tower/%s/stop/stop1.png"% STSName)
			"skill": pictureGet = load("res://assets/objects/skill/%s.png"% STSName)
		STSData[STSName]["collBox"] = pictureGet.get_size()
	file = null 
	
	file = FileAccess.open("res://data/level.json", FileAccess.READ)#res://data
	content = file.get_as_text()
	jsonValue = JSON.new()
	jsonValue.parse(content)
	LevelData = jsonValue.data
	file = null
	
#	for k in Level+1:#记录到目前为止的关卡出现了哪些怪
#		if k > 0:
#			for i in LevelData[k]["groups"].size():
#				for j in LevelData[k]["groups"][i]["soldier"]:
#					if !NowMonsterObject.has(j): NowMonsterObject.append(j)

#	file = FileAccess.open("user://text.json", FileAccess.READ)#res://data
#	content = file.get_as_text()
#	jsonValue = JSON.new()
#	jsonValue.parse(content)
#	TextData = jsonValue.data
#	file = null
	
	#保存例子效果的场景
	pass

func closeWindow():#存储数据
#	var saveJson = {"Point":Point,"Brought":Brought,"Level":Level}
#	var json = JSON.new()
#	var save = FileAccess.open("user://playerData.json",FileAccess.WRITE)
#	save.store_string(JSON.stringify(saveJson))
#	save = null
	pass


#const ProSpeed = {"arrow":4,"snowball":3}
#const ProPos = {"arrow":Vector2(0,1.5),"arrowUp":Vector2(0,1.5),"tnt":Vector2(0,4),"fireBall":Vector2(0,0),"fireBallDown":Vector2(0,0),"water":Vector2(0,0)}
#enum DamageMethod {NEARSINGLE,NEARAOE,FAR}
#const ProGrivaty = 0.8
#const ProHigh = 50
##var ProThrowTime = round(sqrt((2*ProHigh)/ProGrivaty))



