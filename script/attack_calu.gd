extends Node

var projectile
var proMode
var proRange

var aoeModel
var aoeRange
var aoeTime
var aoeTimes


var attackType
var type
var attDefence
var damagerType
var damage
var giveEffect
var effValue
var effTime
var effTimes
var effDefence

func normalAttackCalu(damager):
	type = damager.type
	if type == Global.Type.BASE:
		damager.health -= damage 
		if damagerType.find(type) != -1: damager.health -= Global.effect_calu(damage,Global.Effect.ATTDAMAGE,null,null)
	else:
		attDefence = damager.attDefence
		for i in Global.AttackTypeLength:
			if attackType[i] == true&&attDefence[i] == false: 
				if damager.health>0&&damager.shield <=0: 
					damager.health -= damage 
					if damagerType.find(type) != -1: damager.health -= Global.effect_calu(damage,Global.Effect.ATTDAMAGE,null,null)
					#特定目标伤害加成
				if damager.shield >0:#护盾被破坏时伤害溢出
					damager.shield -= damage
		effectAttackCalu(damager)
	pass

func effectAttackCalu(damager):	
	effDefence = damager.effDefence
	for i in Global.EffectLength:
		if (giveEffect[i] == Global.EFFBAD&&effDefence[i] == false)||(giveEffect[i] == Global.EFFGOOD): 
			if damager.health>0:
				match i:
					Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.ATTRANGE,Global.Effect.HOLDDAMAGE:
						if damager.nowEffect[i] != Global.OFFEFFECT:
							if damager.nowEffect[i] != giveEffect[i]:
								damager.effUncencal[i] = Global.CENCAL#处在同效果不同态度时效果抵消
						else: 
							damager.nowEffect[i] = giveEffect[i]
							match i:
								Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.ATTRANGE:
									damager.attributeTimer(i)
							match i:
								Global.Effect.HOLDDAMAGE: damager.posionTimer(i)
				match i:
					Global.Effect.DAMAGE:
						if damager.health<damager.healthUp: damager.health += Global.EffMulti[i]*giveEffect[i]
					Global.Effect.KNOCK: damager.position.x -= Global.EffMulti[i]*damager.camp
	queue_free()
	pass
	
	
