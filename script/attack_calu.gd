extends Node

var projectile
var proMode
var proRange

var ifAoeHold
var aoeModel
var aoeRange

var attackType
var attDefence
var damagerType
var damage
var giveEffect
var effDefence

func normalAttackCalu(damager):
	if damager.type == Global.Type.BASE:
		damager.health -= damage 
	else:
		attDefence = damager.attDefence
		for i in Global.AttackTypeLength:
			if attackType[i] == true&&attDefence[i] == false: 
				if damager.health>0&&damager.shield <=0: 
					damager.health -= damage 
					#if damager.type == damagerType: damager.health -= Global.effect_calu(damage,Global.Effect.ATTDAMAGE,null,null)
					#特定目标伤害加成
				if damager.shield >0: 
					damager.shield -= damage
		effectAttackCalu(damager)
	pass

func effectAttackCalu(damager):	
	effDefence = damager.effDefence
	for i in Global.EffectLength:
		if (giveEffect[i] == Global.EFFBAD&&effDefence[i] == false)||(giveEffect[i] == Global.EFFGOOD): 
			if damager.health>0:
				match i:
					Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.ATTRANGE,Global.Effect.POISON,Global.Effect.FIRE:
						if damager.nowEffect[i] != Global.OFFEFFECT:
							if damager.nowEffect[i] != giveEffect[i]:
								damager.effUncencal[i] = Global.CENCAL#处在同效果不同态度时效果抵消
						else: 
							damager.nowEffect[i] = giveEffect[i]
							match i:
								Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.ATTRANGE:
									damager.attributeTimer(i)
							match i:
								Global.Effect.POISON: damager.posionTimer(i)
								Global.Effect.FIRE: damager.fireTimer(i)
				if i == Global.Effect.DAMAGE:
					damager.health += Global.AttEffValue[i]*giveEffect[i]
				match i:
					Global.Effect.KNOCK1,Global.Effect.KNOCK2,Global.Effect.KNOCK3:
						damager.position.x -= Global.AttEffValue[i]*damager.camp
	queue_free()
	pass
	
	
