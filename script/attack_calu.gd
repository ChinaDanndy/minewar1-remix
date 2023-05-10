extends Node


var aoeModel
var aoeRange
var aoeTime
var aoeTimes

var ifAoe
enum aoeHold {IN,OUT,NONE}

var attackType
var damagerType
var damage

var type
var attDefence

var giveEffect

var effValue
var effTime
var effTimes

var effDefence
var effBasic = [0,0,0,0]
func normalAttackCalu(damager):
	attDefence = damager.attDefence
	for i in Global.AttackTypeLength:
		if attackType[i] == true&&attDefence[i] == false: 
			if damager.health>0&&damager.shield <=0: 
				damager.health -= damage 
				if damagerType.find(damager.type) != -1: damager.health -= damage*1.5
					#特定目标伤害加成
			if damager.shield >0:#护盾被破坏时伤害溢出
				damager.shield -= damage
	effectAttackCalu(damager)
	pass


func effectAttackCalu(damager):	
	effDefence = damager.effDefence
	effBasic[0] = damager.damageBasic
	effBasic[1] = damager.speedBasic
	effBasic[2] = damager.attRangeBasic
	effBasic[3] = damager.aniSpeedBasic
	for i in Global.EffectLength:
		if (giveEffect[i] == Global.EFFBAD&&effDefence[i] == false)||(giveEffect[i] == Global.EFFGOOD): 
			if damager.health>0:
				match i:
					Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.FREEZE,Global.Effect.ATTRANGE:
						var this = i
						if giveEffect[i] == Global.EFFGOOD: this = i+4
						damager.nowEffect[this] = effBasic[i]*giveEffect[i]*Global.EffValue[i]
						if i==Global.Effect.SPEED: damager.nowEffect[this+2] = effBasic[3]*giveEffect[i]*Global.EffValue[i]
						if damager.effTimerId[this] == null:
							
							if ifAoe == Global.IfAoeType.NONE: damager.effectTimer(i,effTime[i],giveEffect[i])
						else:
							match ifAoe:					#新计时器时间是否大于旧的计时器剩余时间
								Global.IfAoeType.NONE: 
									if effTime[i]>damager.effTimerId[this].time_left: damager.effTimerId[this].start(effTime[i])
								Global.IfAoeType.IN: damager.effTimerId[this].stop()#防止处于范围持续被时间持续打断
						if ifAoe == Global.IfAoeType.OUT: damager.effectTimerTimeout(i,giveEffect[i])
				match i:
					Global.Effect.HOLDDAMAGE: 
						damager.holdDamageTimer(effTime[i],effTimes[Global.DamValue.HOLDDAMAGE],effValue[Global.DamValue.HOLDDAMAGE]*giveEffect[i])
					Global.Effect.DAMAGE:
						
						if (damager.health+effValue[Global.DamValue.DAMAGE]*giveEffect[i])<=damager.healthUp: 
							damager.health += effValue[Global.DamValue.DAMAGE]*giveEffect[i]
						else: damager.health = damager.healthUp
					Global.Effect.KNOCK: damager.position.x -= effValue[Global.DamValue.KNOCK]*damager.camp
	
	

	
	

	
	queue_free()
	pass
	
	
