extends Node
var STSData:Dictionary
enum STSType {INT,ARRAY}
const STSDataName = {"price":STSType.INT,"kind":STSType.INT,
"collKind":STSType.INT,"health":STSType.INT,"type":STSType.INT,"towKeepTime":STSType.INT,"soldierName":null,
"animation":null,"seaAniNumber":STSType.INT,"aniTimeBasic":null,"speedBasic":null,"ifOnlyAttBase":null,
"attackType":null,"damageMethod":STSType.INT,"damagerType":STSType.ARRAY,"damageBasic":null,"projectile":null,
"proMode":STSType.INT,"attRangeBasic":STSType.INT,"proSleepTime":STSType.INT,"proContinueTimes":STSType.INT,"aoeModel":STSType.ARRAY,"aoeRange":STSType.ARRAY,"aoeTime":STSType.ARRAY,"aoeTimes":STSType.ARRAY,
"effValue":null,"effTime":STSType.ARRAY,"effTimes":STSType.INT,"attackEffect":null,"usuallyEffect":null,
"deathEffect":null,"ifFirstEffect":null,"ifHealthEffect":null,"healthEffValue":STSType.INT,"ifDistanceEffect":null,"shield":STSType.INT,
"attDefShield":null,"satDefValue":STSType.INT,"attDefState":null}
var Contrl
const Money = 10 
var NowMoney = 10
var LevelData
var Level = 0
enum  LevelType {ATTACK,ATTDEF,DEFENCE}
#var arrow = load("res://assets/projectiles/arrow.png")

const MoneyTime = 1.5
const DropSpeed = 20 
const NormalAOERangeY = 20
const SkillAOERangeY = 300




#近 靠近效果 单陆地远 仅地面地远 地空地远 空地分开空 空地同时空
enum CollKind {NARE,NARESPE,LAND,LANDSKY,SKY,SKYLAND}
const Coll2IfUse = [false,true,false,true,true,true]
enum Type {PEOPLE,TOWER,SKILL,PROJECTILE,BASE}
enum Kind {LAND,SEA,SKY}
enum DamageMethod {NEARSINGLE,NEARAOE,FAR}
var AttackTypeLength = 3
enum AoeSet {ATTACK,NORMAL,DEATH}
enum Effect {ATTDAMAGE,SPEED,ATTRANGE,DAMAGE,HOLDDAMAGE,KNOCK}
enum DamValue {DAMAGE,HOLDDAMAGE,KNOCK}
const EffValue = [0.5,0.5,0.5]
var EffectLength = Effect.size()
const HoldEffectTime = 3
const HoldEffectTimes = 5
const EffTime = 5
const EffMulti = [0.5,1,0.25,1,2,1,25,50,100]
const CENCAL = 0
const UNCENCAL = 1

const EFFGOOD = 3
const OFFEFFECT = 0
const EFFBAD = 1


#enum Projectile {ARROW1,BOMB1,SNOWBALL}
#enum ProType {NORMAL,PIERCE,FINAL}
#const ProTypeValue = [ProType.NORMAL,ProType.FINAL]
#const ProName = ["arrow","snowball"]
const ProPos = {"arrow":Vector2(0,1.5),"snowball":Vector2(0,2)}
const ProDire = {"arrow":Vector2(1,0),"snowball":Vector2(1,0)}
const ProSpeed = {"arrow":4,"snowball":3}
const ProPicture = {"arrow":1,"snowball":1}
const ProAniTime = {"arrow":0,"snowball":0}


const ProGrivaty = 0.8
const ProHigh = 50

var ProThrowTime = round(sqrt((2*ProHigh)/ProGrivaty))



@onready var root = get_tree().get_root()

var LevelChoiceButton
var LevelChoiceWindow

var FightSence
var SummonEnemy
var StopButton
var StopWindowLayer
var StopWindow
var FightGroundY
var VillagePoint
var MonsterPoint
var VillageBase
var MonsterBase
var towerArea
var skillArea

var CardBuy
var Projectile = preload("res://sence/projectiles.tscn")
var VillageSoldier = preload("res://sence/villageSoldier.tscn")
var VillageTower = preload("res://sence/villageTower.tscn")
var MonsterSoldier = preload("res://sence/monsterSoldier.tscn")
var calu = preload("res://script/attack_calu.gd")
var aoe = preload("res://sence/AOE.tscn")
var OutLine = preload("res://rescourse/outLine.tres")
var ChoiceArea = preload("res://sence/choiceArea.tscn")

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
	
const CREATE = 0
func aoe_create(damager,type,aoeModel,aoeRange,ifAoeHold):
	var newAoe = aoe.instantiate()
	var target = newAoe
	if type == TRANSFER: target = damager
	target.aoeModel = aoeModel
	target.aoeRange = aoeRange
	target.ifAoeHold = ifAoeHold
	if damager != TRANSFER:
		root.add_child(newAoe)
		newAoe.position = damager.position
		newAoe.firstsetting()
	else: newAoe.free()
	pass

	
const VILLAGE = 1
const MONSTER = -1
const MIDDLE = 0
#MONSTER,ALL,VILLAGE
const LAyer = [[2,8,32],[1+2+16+32],[1,4,16]]
#碰撞层：敌方普通，敌方海,敌方基地,敌友全部除海,全部，我方普通，我方海，我方基地
const MAsk = [[1+16,1+4+16,16],[1+2+16+32],[2+32,2+8+32,32]]
const deathLayer = 32


