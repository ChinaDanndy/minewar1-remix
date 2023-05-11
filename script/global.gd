extends Node
@onready var root = get_tree().get_root()
var STSData:Dictionary
enum STSType {INT,ARRAY}
const STSDataName = {"price":STSType.INT,"kind":STSType.INT,
"collKind":STSType.INT,"health":STSType.INT,"type":STSType.INT,"towKeepTime":STSType.INT,"soldierName":null,
"animation":null,"seaAniNumber":STSType.INT,"aniTimeBasic":null,"speedBasic":null,"ifOnlyAttBase":null,
"attackType":null,"damageMethod":STSType.INT,"damagerType":STSType.ARRAY,"damageBasic":null,"projectile":null,
"proMode":STSType.INT,"attRangeBasic":STSType.INT,"proSleepTime":STSType.INT,"proContinueTimes":STSType.INT,"aoeModel":null,"aoeRange":null,"ifAoeHold":null,
"effValue":null,"effTime":null,"effTimes":null,"effDefence":null,"attackEffect":null,"usuallyEffect":null,
"deathEffect":null,"ifFirstEffect":null,"ifHealthEffect":null,"healthEffValue":STSType.INT,"ifDistanceEffect":null,"attDefOrigin":null,"shield":STSType.INT,
"attDefShield":null,"satDefValue":STSType.INT,"attDefState":null}
var ThunderSpeed
const Money = 10 
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
const deathLayer = 32
#近 靠近效果 单陆地远 仅地面地远 地空地远 空地分开空 空地同时空
enum CollKind {NARE,NARESPE,LAND,LANDSKY,SKY,SKYLAND}
const Coll2IfUse = [false,true,false,true,true,true]
enum Type {SOLDIER,TOWER,SKILL,PROJECTILE,BASE}
enum Kind {LAND,SEA,SKY}
enum DamageMethod {NEARSINGLE,NEARAOE,FAR}
enum AttackType {NEAR,FAR,EXPLODE}
var AttackTypeLength = AttackType.size()

enum Effect {ATTDAMAGE,SPEED,FREEZE,ATTRANGE,DAMAGE,HOLDDAMAGE,KNOCK}
enum DamValue {DAMAGE,HOLDDAMAGE,KNOCK}
const EffValue = [0.5,0.5,0,0.5]
var EffectLength = Effect.size()
const EFFGOOD = 1
const OFFEFFECT = 0
const EFFBAD = -1

const ProPos = {"arrow":Vector2(0,1.5),"snowball":Vector2(0,2)}
const ProDire = {"arrow":Vector2(1,0),"snowball":Vector2(1,0)}
const ProSpeed = {"arrow":4,"snowball":3}
const ProPicture = {"arrow":1,"snowball":1}
const ProAniTime = {"arrow":0,"snowball":0}

#const ProGrivaty = 0.8
#const ProHigh = 50
##var ProThrowTime = round(sqrt((2*ProHigh)/ProGrivaty))

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
	if type != TRANSFER:
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
	if type != TRANSFER:
		root.add_child(newAoe)
		newAoe.firstsetting()
		newAoe.position = damager.position
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
	



