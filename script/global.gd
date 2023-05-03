extends Node
var STSData:Dictionary
enum STSType {INT,ARRAY}
const STSDataName = {"price":STSType.INT,"camp":STSType.INT,"kind":STSType.INT,
"collKind":STSType.INT,"health":STSType.INT,"type":STSType.INT,"towKeepTime":STSType.INT,"soldierName":null,"totalPictureNumber":STSType.INT,
"animationStart":STSType.ARRAY,"animationEnd":STSType.ARRAY,"othanimationStart":STSType.ARRAY,"othanimationEnd":STSType.ARRAY,"seaAniNumber":STSType.INT,"speedBasic":null,"ifOnlyAttBase":null,
"attackType":null,"damageMethod":STSType.INT,"damagerType":null,"damageBasic":STSType.INT,"projectile":STSType.INT,
"proMode":STSType.INT,"attRangeBasic":STSType.INT,"proSleepTime":STSType.INT,"proContinueTimes":STSType.INT,"ifAoeHold":null,"aoeModel":STSType.ARRAY,"aoeRange":STSType.ARRAY,
"attEffGoodOrBad":STSType.ARRAY,"attackEffect":null,"usuallyEffGoodOrBad":STSType.ARRAY,"usuallyEffect":null,"deathEffGoodOrBad":STSType.ARRAY,
"deathEffect":null,"ifFirstEffect":null,"ifHealthEffect":null,"healthEffValue":STSType.INT,"ifDistanceEffect":null,"shield":STSType.INT,
"attDefShield":null,"satDefValue":STSType.INT,"attDefState":null}
var Contrl
const Money = 10 
var NowMoney = 0
var LevelData
var Level = 0

var arrow = load("res://assets/projectiles/arrow.png")

const MoneyTime = 1
const DropSpeed = 20 
const NormalAOERangeY = 20
const SkillAOERangeY = 300




#近 靠近效果 单陆地远 仅地面地远 地空地远 空地分开空 空地同时空
enum CollKind {NARE,NARESPE,LAND,LANDSKY,SKY,SKYLAND}
const Coll2IfUse = [false,true,false,true,true,true]
enum Type {PEOPLE,TOWER,PROJECTILE,BASE,SKILL}
enum Kind {LAND,SEA,SKY}
enum DamageMethod {NEARSINGLE,NEARAOE,FAR}
var AttackTypeLength = 3
enum AoeSet {ATTACK,NORMAL,DEATH}
enum Effect {ATTDAMAGE,SPEED,ATTRANGE,POISON,FIRE,DAMAGE,KNOCK1,KNOCK2,KNOCK3}
var EffectLength = Effect.size()
const HealthReduceTime = 2
const HoldEffectTimes = 5
const EffTime = 1
const EffMulti = [0.5,1,0.25,1,2,1,25,50,100]
const CENCAL = 0
const UNCENCAL = 1
const EFFGOOD = 1
const OFFEFFECT = 0
const EFFBAD = -1

enum ProMode {HLINE,VLINE,DBELVE,UBELVE,HTHROW,ATHROW}
const ProModeValue = [Vector2(1,0),Vector2(0,1),Vector2(1,-1),Vector2(-1,1)]
enum Projectile {ARROW1,BOMB1}
enum ProType {NORMAL,PIERCE,FINAL}
const ProTypeValue = [ProType.NORMAL,ProType.FINAL]
const ProPos = [Vector2(0,1.5),Vector2(0,-12)]
const ProName = ["arrow","bomb1"]
const ProSpeed = [4,2]
const ProPicture = [1,4]
const ProAniTime = [0,0.5]


const ProGrivaty = 0.8
const ProHigh = 50

var ProThrowTime = round(sqrt((2*ProHigh)/ProGrivaty))



@onready var root = get_tree().get_root()

var LevelChoiceButton
var LevelChoiceWindow

var FightSence
var StopButton
var StopWindowLayer
var StopWindow
var FightGroundY
var VillagePoint
var MonsterPoint
var towerArea
var skillArea

var CardBuy
var Soldier = preload("res://sence/soldiers.tscn")
var calu = preload("res://script/attack_calu.gd")
var aoe = preload("res://sence/AOE.tscn")
var OutLine = preload("res://rescourse/outLine.tres")
var ChoiceArea = preload("res://sence/choiceArea.tscn")
enum Calu {ATTEFF,EFF}
enum TRtype {VALCALU,VALCREATE}

func effect_calu(value,effectName,effectGoodOrBad,effectUncencal):
	#原始值+增值*是否处于该效果*好或坏*是否同时获得好坏值中和攻击效果恢复为原值
	if effectGoodOrBad == null: 
		return value*EffMulti[effectName]
	else: 
		return value*EffMulti[effectName]*effectGoodOrBad[effectName]*effectUncencal[effectName]
	pass

func TRvalue_caluORcreate(caluType,damager,target,projectile,proMode,proRange,ifAoeHold,aoeModel,aoeRange,attackType,damage,damagerType,giveEffect):
	var newCalu = calu.new()
	var newAoe = aoe.instantiate()
	match target:
		TRtype.VALCALU: 
			target = newCalu
			newAoe.free()
		TRtype.VALCREATE: 
			target = newAoe
			newCalu.free()
			
	target.projectile = projectile
	target.proMode = proMode
	target.proRange = proRange
	
	target.ifAoeHold = ifAoeHold
	target.aoeModel = aoeModel
	target.aoeRange = aoeRange
	
	target.attackType = attackType
	target.damage = damage
	target.damagerType = damagerType
	target.giveEffect = giveEffect
	match caluType:
		Calu.ATTEFF: newCalu.normalAttackCalu(damager)
		Calu.EFF: newCalu.effectAttackCalu(damager)
			
	if target == newAoe: 
		root.add_child(newAoe)
		newAoe.position = damager.position
		newAoe.firstsetting()
	pass
	


const VILLAGE = 1
const MONSTER = -1
const MIDDLE = 0
#MONSTER,ALL,VILLAGE
const LAyer = [[2,8,32],[1+2+16+32],[1,4,16]]
#碰撞层：敌方普通，敌方海,敌方基地,敌友全部除海,全部，我方普通，我方海，我方基地
const MAsk = [[1+16,1+4+16,16],[1+2+16+32],[2+32,2+8+32,32]]
const deathLayer = 32


