extends Node
@onready var root = get_tree().get_root()
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
var ThunderSpeed
const Money = 100
var NowMoney = 0
var CardBuy = null
var Contrl = null

var LevelData
var Level = 1
enum  LevelType {ATTACK,ATTDEF,DEFENCE}
var LevelOver = false

const DropSpeed = 20 
const NormalAOERangeY = 20
const SkillAOERangeY = 300






const VILLAGE = 1
const MONSTER = -1
const MIDDLE = 0
#MONSTER,ALL,VILLAGE
const LAyer = [[2,8,32],[1+2+16+32],[1,4,16]]
#碰撞层：敌方普通，敌方海,敌方基地,敌友全部除海,全部，我方普通，我方海，我方基地
const MAsk = [[1+16,1+4+16,16],[1+2+16+32],[2+32,2+8+32,32]]
#const deathLayer = 32
enum AttackType {NEAR,FAR,EXPLODE}
const AddDamage = 1.5
enum Effect {ATTDAMAGE,ATTRANGE,SPEED,FREEZE,DAMAGE,HOLDDAMAGE,KNOCK}
const EffGood = Effect.DAMAGE
enum DamValue {DAMAGE,HOLDDAMAGE,KNOCK}
const EffValue = [0.5,0.5,0.5,0]
const EFFGOOD = 1
const OFFEFFECT = 0
const EFFBAD = -1


const ProDire = {"arrow":Vector2(1,0),"arrowUp":Vector2(1,-1),"tnt":Vector2(0,1),
"fireBall":Vector2(1,0),"fireBallDown":Vector2(1,1),"water":Vector2(1,0),"snowBall":Vector2(1,0)}
const ProPicture = {"arrow":1,"arrowUp":1,"tnt":1,"fireBall":1,"fireBallDown":1,"water":1,"snowBall":1
}
const ProAniTime = {"arrow":0,"arrowUp":0,"tnt":0,"fireBall":0,"fireBallDown":0,"water":0,"snowBall":0
}

var calu = preload("res://script/fight/calu/attackCalu.gd")
enum damCaluType {ATTEFF,EFF}
const TRANSFER = null
enum IfAoeType {IN,OUT,NONE}
const SkillHold = -1
func damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,ifAoe):
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
	target.ifAoe = ifAoe
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
		#root.call_deferred("add_child",newAoe)
		root.add_child(newAoe)
		newAoe.position = damager.position
		newAoe.firstsetting()
		#newAoe.position.y = FightGroundY
	else: newAoe.free()
	return newAoe
	pass

var LevelChoiceButton
var LevelChoiceWindow

var StopButton
var StopWindowLayer
var StopWindow
var StopON = false

var FightSence
var FightGroundY
var FightSkyY
var VillagePoint
var MonsterPoint
var VillageBase
var MonsterBase
var towerArea
var skillArea

var OutLine = preload("res://rescourse/outLine.tres")
var VillageSoldier = preload("res://sence/fight/object/soldier/villageSoldier.tscn")
var MonsterSoldier = preload("res://sence/fight/object/soldier/monsterSoldier.tscn")
var Tower = preload("res://sence/fight/object/tower.tscn")
var Skill = preload("res://sence/fight/object/skill.tscn")
	
	

#const ProSpeed = {"arrow":4,"snowball":3}
#const ProPos = {"arrow":Vector2(0,1.5),"arrowUp":Vector2(0,1.5),"tnt":Vector2(0,4),"fireBall":Vector2(0,0),"fireBallDown":Vector2(0,0),"water":Vector2(0,0)}
#enum DamageMethod {NEARSINGLE,NEARAOE,FAR}
#const ProGrivaty = 0.8
#const ProHigh = 50
##var ProThrowTime = round(sqrt((2*ProHigh)/ProGrivaty))



