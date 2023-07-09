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
enum Effect {ATTDAMAGE,ATTRANGE,SPEED,HOLDAMAGE,FREEZE,DAMAGE,KNOCK,HEALTH}
const EffGood = Effect.DAMAGE
enum DamValue {HOLDAMAGE,DAMAGE,KNOCK,HEALTH}
const EffValue = [0.5,0.5,0.5,0,0]
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
	else: newAoe.free()
	#return newAoe
	pass

var LevelChoiceWindow
var BuyCardButton
var BuyCardWindow

var MiniGame = 0
var MiniGameWindow
var MiniGameSence
var MiniGameScore
var MiniGame2PosY:Array

var ChoiceWindow
var FightButton
var ChosenCardNum = 0
var ChosenCard = [null,null,null,null,null,null,null]
var ChosenId =  [null,null,null,null,null,null,null]

var StopButton
var StopWindow
var TeachWindow
var CardTextWindow
var AllMonster = [null,null,null,null,null,null]
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
var MonsterBase
var towerArea
var skillArea
var Boss

var CardBuy = null
var Contrl = null

var SoldierOutLine = preload("res://rescourse/soldierOutLine.tres")
var Soldier = preload("res://sence/fight/object/soldier.tscn")
var Tower = preload("res://sence/fight/object/tower.tscn")
var Skill = preload("res://sence/fight/object/skill.tscn")

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

var Point = 0
var Brought = {"cardUpdate":false,"moneyUpate":false,"power":false,"golder":false}
var Level = 1
var Teach = 0

var SeDB = 1.0
var ThunderSpeed
var Money = 10
var NowMoney = 0
var CardUp = 0

var LevelData
var NowLevel = 1
var LevelOver = false
func _ready():#读入数据
	if FileAccess.file_exists("user://playerData.json"):
		var _json = JSON.new()
		var loadData = FileAccess.open("user://playerData.json",FileAccess.READ)
		var waitJson = loadData.get_as_text()
		_json.parse(waitJson)
		Point = _json.data["Point"]
		Brought = _json.data["Brought"]
		Level = _json.data["Level"]
		Teach = _json.data["Teach"]
		loadData = null
	root.close_requested.connect(closeWindow)

	var file = FileAccess.open("res://data/object.json",FileAccess.READ)#user:
	var content = file.get_as_text()#读取所有士兵数据
	var jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.STSData = jsonValue.data
	for STSName in jsonValue.data:#把所有数值变成int,数组要挨个把里面的值重新读
		if STSData[STSName].has("type"):
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
	pass

func closeWindow():#存储数据
	var saveJson = {"Point":Point,"Brought":Brought,"Level":Level,"Teach":Teach}
	var _json = JSON.new()
	var save = FileAccess.open("user://playerData.json",FileAccess.WRITE)
	save.store_string(JSON.stringify(saveJson))
	save = null
	pass

func _process(_delta):
	if Input.is_action_just_pressed("screenShoot"):
		var nowTime = Time.get_datetime_dict_from_system()
		get_viewport().get_texture().get_image().save_png("user://%sY%sM%sD%sH%sM%sS.png"
		%[nowTime["year"],nowTime["month"],nowTime["day"],
		nowTime["hour"],nowTime["minute"],nowTime["second"],])#截图
		pass
	pass


