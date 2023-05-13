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

func _ready():
	$ColorRect.visible = false
	Global.FightSence.reloadSence.connect(reload)
	if ifAoeHold == false: 
		await get_tree().create_timer(0.04,false).timeout
		queue_free()
	pass

func firstsetting():
	collision_mask = Global.LAyer[aoeModel][0]

	var newRange = RectangleShape2D.new()#AOE范围
	newRange.size = Vector2(aoeRange,Global.NormalAOERangeY)
	if damagerType !=null:
		match damagerType[0]:
			"skill": newRange.size = Vector2(aoeRange,Global.SkillAOERangeY)#换范围
			#"thunder": $CollisionShape2D.position.y = Global.STSData["thunder"]["collBox"].y/2-20#换位置
	$CollisionShape2D.shape = newRange
	if ifAoeHold == true: 
		$ColorRect.position = Vector2(aoeRange/-2,-10)
		$ColorRect.size = Vector2(aoeRange,20)
		$ColorRect.visible = true
		if damage != null:#单位攻击有范围持续的效果先判定一次攻击伤害
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes)
		if giveEffect[Global.Effect.DAMAGE] != Global.OFFEFFECT:#平常情况下的伤害类型范围持续效果
			print(effTimes[Global.DamValue.DAMAGE])
			$holdTimer.start(effTime[Global.Effect.DAMAGE])
			#$deathTimer.start(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE])
			await get_tree().create_timer(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE],false).timeout
			queue_free()
	pass

func _process(delta):
	
	pass
func _on_area_entered(area):
	#var noDamageEffect = giveEffect.duplicate()
	#noDamageEffect[Global.Effect.DAMAGE] = 0#防止平时持续效果里给伤害时给属性效果续时间
			#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):	else:#AOE
	if damage == null: 
		#if damagerType == null: 
		Global.damage_Calu(area,Global.damCaluType.EFF,null,null,null,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
	else:
		Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
	if ifAoeHold == false: 
		#if damagerType != null&&damagerType[0] == "skill":

			#Global.damage_Calu(area,Global.damCaluType.EFF,null,null,null,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
		queue_free()
	pass
	
func _on_hold_timer_timeout():
	#var nolyDamageEffect:Array
	#for i in Global.Effect.size(): nolyDamageEffect[i] = 0
	#nolyDamageEffect[Global.Effect.DAMAGE] = giveEffect[Global.Effect.DAMAGE]#防止平时持续效果里给伤害时给属性效果续时间
	print("aaaaa")
	Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,null,["skill"],giveEffect,effValue,effTime,effTimes)
	pass

func _on_death_timer_timeout():
	queue_free()
	pass # Replace with function body.

func reload():
	queue_free()
	pass 















