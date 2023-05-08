extends Area2D
var kind = Global.Type.SKILL

var aoeModel
var aoeRange
var ifAoeHold

var attackType
var damagerType
var damage
var giveEffect
var effValue
var effTime
var effTimes
var ifAoe


func _ready():
	$ColorRect.visible = false
	Global.FightSence.reloadSence.connect(reload)
	pass

func _process(_delta):
	pass

func firstsetting():
	collision_mask = Global.LAyer[aoeModel][0]
	if ifAoeHold == true: 
		$ColorRect.position = Vector2(aoeRange/-2,-10)
		$ColorRect.size = Vector2(aoeRange,20)
		$ColorRect.visible = true
		if damage != null:#单位攻击有范围持续的效果先判定一次攻击伤害
			Global.damage_Calu(self,Global.TRANSFER,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,null)
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false)
		if giveEffect[Global.Effect.DAMAGE] != Global.OFFEFFECT:#平常情况下的伤害类型范围持续效果
			$holdTimer.start(effTime[Global.Effect.DAMAGE])
			await get_tree().create_timer(effTime[Global.Effect.DAMAGE]*effTimes[Global.Effect.DAMAGE],false).timeout
			queue_free()
	else:
		var newRange = RectangleShape2D.new()#AOE范围
		newRange.size = Vector2(aoeRange,Global.NormalAOERangeY)
		if ifAoe == Global.SkillHold: newRange.size = Vector2(aoeRange,Global.SkillAOERangeY)
		$CollisionShape2D.shape = newRange
	pass
func _on_Node2D_body_entered(body):
		#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):	else:#AOE
	if ifAoeHold == false:
		if damage == null: 
			Global.damage_Calu(body,Global.damCaluType.EFF,null,null,null,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
		else:
			Global.damage_Calu(body,Global.damCaluType.ATTEFF,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
		queue_free()
	else: Global.damage_Calu(body,Global.damCaluType.EFF,null,null,null,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.IN)
	pass
func _on_body_exited(body):
	if ifAoeHold == true: 	Global.damage_Calu(body,Global.damCaluType.EFF,null,null,null,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.OUT)
	pass 

func _on_hold_timer_timeout():
	Global.damage_Calu(self,Global.TRANSFER,null,null,null,giveEffect[Global.Effect.DAMAGE],effValue,null,null,null)
	Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false)
	pass

func reload():
	queue_free()
	pass 



