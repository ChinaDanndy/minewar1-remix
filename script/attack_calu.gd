extends Node
var damageMethod
var aoeModel
var ifProPierce
var proRange
var aoeRange
var ifAoeHold

var damagerType
var attackType
var damage
var attDefence

var giveEffect
var giveEffGoodOrBad
var effDefence
func normalAttackCalu(damager):
	attDefence = damager.attDefence
	
	for i in 4:
		if attackType[i] == true&&attDefence[i] == false: 
			if damager.health>0: 
				damager.health -= damage 
				if damager.type == damagerType: damager.health -= Global.effect_calu(damage,Global.Effect.ATTDAMAGE,null,null)
					#特定目标伤害加成
	effectAttackCalu(damager)
	pass

func effectAttackCalu(damager):
	effDefence = damager.effDefence
	var effectName = 0
	#print(nowEffGoodOrBad)
	for i in 9:
		#effectName += 1
		if (giveEffGoodOrBad[i]==Global.EFFBAD&&giveEffect[i] == true&&effDefence[i] == false)||(giveEffGoodOrBad[i]==Global.EFFGOOD&&giveEffect[i] == true): 
			if damager.health>0:
				match i:
					Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.ATTRANGE,Global.Effect.POISON,Global.Effect.FIRE:
						if damager.nowEffect[i] == Global.ONEFFECT:
							if damager.nowEffGoodOrBad[i] != giveEffGoodOrBad[i]:
								damager.effUncencal[i] = Global.CENCAL#处在同效果不同态度时效果抵消
						else:
							damager.nowEffect[i] = Global.ONEFFECT
							damager.nowEffGoodOrBadhealth[i] = giveEffGoodOrBad[i]
							match i:
								Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.ATTRANGE:
									damager.attributeTimer(i)
							match i:
								Global.Effect.POISON:
									damager.posionTimer(i)
								Global.Effect.FIRE:
									damager.fireTimer(i)
				if i == Global.Effect.DAMAGE:
					damager.health += Global.AttEffValue[i]*giveEffGoodOrBad[i]
				match i:
					Global.Effect.KNOCK1,Global.Effect.KNOCK2,Global.Effect.KNOCK3:
						damager.position.x -= Global.AttEffValue[i]*damager.camp
	
	queue_free()
	pass
