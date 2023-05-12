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
var effBasic = [0,0,0,0,0]
func normalAttackCalu(damager):
	attDefence = damager.attDefence
	for i in Global.AttackType.size():
		if attackType[i] == true&&attDefence[i] == false: 
			if damager.health>0&&damager.shield <=0: 
				damager.health -= damage 
				if damagerType.find(damager.type) != -1: damager.health -= damage*Global.AddDamage
					#特定目标伤害加成
			if damager.shield >0:#护盾被破坏时伤害溢出
				damager.shield -= damage
	effectAttackCalu(damager)
	pass


func effectAttackCalu(damager):	
	effDefence = damager.effDefence
	for i in Global.Effect.size():
		if (giveEffect[i] == Global.EFFBAD&&effDefence[i] == false)||(giveEffect[i] == Global.EFFGOOD): 
			if damager.health>0:
				match i:
					Global.Effect.ATTDAMAGE,Global.Effect.SPEED,Global.Effect.FREEZE,Global.Effect.ATTRANGE:
						var this = i
						if giveEffect[i] == Global.EFFGOOD: this = i+Global.Effect.DAMAGE
						damager.nowEffect[this] = Global.EffValue[i]
						if i==Global.Effect.SPEED: damager.nowEffect[this+1] = Global.EffValue[i]
						
						if damager.effTimerId[this] == null:
							damager.effectTimer(i,effTime[i],giveEffect[i])
						else:	if effTime[i]>damager.effTimerId[this].time_left: damager.effTimerId[this].start(effTime[i])
							#新计时器时间是否大于旧的计时器剩余时间
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
	
	
