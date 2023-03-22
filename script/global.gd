extends Node


var SoldierData
var Contrl
const Money = 10 
var NowMoney = 0
var LevelData
var Level = 0
var CardId:Array

enum Type {PEOPLE,TOWER,PROJECTILE,BASE,SKILL}
enum Kind {LAND,SEA,SKY}
enum AttackType {IMMDAMAGE,MAGIC,EXPLODE,PROJECTILE}
const AttackTypeLength = 4
enum DamageMethod {SINGAL,AOE}
const HealthReduceTime = 2
const HoldEffectTimes = 2
enum AoeModel {MONSTER,ALL,VILLAGE}
enum Effect {ATTDAMAGE,SPEED,ATTRANGE,POISON,FIRE,DAMAGE,KNOCK1,KNOCK2,KNOCK3}
const EffectLength = 9
const EffTime = 2
const EffMulti = [0.5,1,0.25,2,0,5,1,10,100,25,50]
const ONEFFECT = 1
const OFFEFFECT = 0
const CENCAL = 0
const UNCENCAL = 1
const EFFGOOD = 1
const EFFBAD = -1

@onready var root = get_tree().get_root()

var LevelChoiceButton
var LevelChoiceWindow

var FightSence
var StopButton
var StopWindowLayer
var StopWindow

var Soldier = preload("res://sence/soldiers.tscn")
var calu = preload("res://script/attack_calu.gd")
var aoe = preload("res://sence/AOE.tscn")
var OutLine = preload("res://rescourse/soldiers.tres")
enum Calu {ATTEFF,EFF}
enum TRtype {VALCALU,VALCREATE}
enum AoeSet {ATTACK,NORMAL,DEATH}

func _ready():
	
	#print(root)
	pass

func effect_calu(value,effectName,effectGoodOrBad,effectUncencal):
	#原始值+增值*是否处于该效果*好或坏*是否同时获得好坏值中和攻击效果恢复为原值
	if effectGoodOrBad == null: return value*EffMulti[effectName]
	else: 
		return value*EffMulti[effectName]*effectGoodOrBad[effectName]*effectUncencal[effectName]
	pass

func TRvalue_caluORcreate(caluType,damager,target,ifProPierce,damageMethod,proRange,aoeModel,aoeRange,ifAoeHold,attackType,damage,damagerType,giveEffect,giveEffGoodOrBad):
	var newCalu = calu.new()
	var newAoe = aoe.instantiate()
	match target:
		TRtype.VALCALU: 
			target = newCalu
			newAoe.free()
		TRtype.VALCREATE: 
			target = newAoe
			newCalu.free()
			
	target.ifProPierce = ifProPierce
	target.damageMethod = damageMethod
	target.proRange = proRange
	target.ifAoeHold = ifAoeHold
	target.aoeModel = aoeModel
	target.aoeRange = aoeRange
	target.attackType = attackType
	target.damage = damage
	target.damagerType = damagerType
	target.giveEffect = giveEffect
	target.giveEffGoodOrBad = giveEffGoodOrBad
	
	match caluType:
		Calu.ATTEFF:
			newCalu.normalAttackCalu(damager)
		Calu.EFF:
			newCalu.effectAttackCalu(damager)
			
	if target == newAoe: 
		root.add_child(newAoe)
		newAoe.position = damager.position
		newAoe.firstsetting()
		
	pass
	



#近 靠近效果 单陆地远 仅地面地远 地空地远 空地分开空 空地同时空
enum CollKind {NARE,NARESPE,LAND,LANDSKY,SKY,SKYLAND}
const Coll2IfUse = [false,true,false,true,true,true]


const VILLAGE = 1
const MONSTER = -1
const MIDDLE = 0

const LAyer = [[2,8,32],null,[1,4,16]]
#碰撞层：敌方普通，敌方海,敌方基地,敌友全部除海，我方普通，我方海，我方基地
const MAsk = [[1+16,1+4+16,16],[1+2+16+32,0],[2,2+8+32,32]]
const deathLayer = 32


