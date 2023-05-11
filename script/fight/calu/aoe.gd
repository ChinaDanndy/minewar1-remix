extends Area2D
var kind = Global.Type.SKILL

var aoeModel
var aoeRange
var ifAoeHold

var attackType
var damagerType
var damage
var giveEffect
var noDamageEffect
var onlyDamageEffect = [0,0,0,0,0,0,0]
var effValue
var effTime
var effTimes

func _ready():
	$ColorRect.visible = false
	Global.FightSence.reloadSence.connect(reload)
	pass

func firstsetting():
	noDamageEffect = giveEffect
	noDamageEffect[Global.Effect.DAMAGE] = 0#防止平时持续效果里给伤害时给属性效果蓄时间
	onlyDamageEffect[Global.Effect.DAMAGE] = giveEffect[Global.Effect.DAMAGE]
	collision_mask = Global.LAyer[aoeModel][0]
	var newRange = RectangleShape2D.new()#AOE范围
	newRange.size = Vector2(aoeRange,Global.NormalAOERangeY)
	if damagerType !=null:
		match damagerType[0]:
			"skill": newRange.size = Vector2(aoeRange,Global.SkillAOERangeY)#换范围
			#"thunder": $CollisionShape2D.position.y = Global.STSData["thunder"]["collBox"].y/2-20#换位置
	$CollisionShape2D.shape = newRange
	if ifAoeHold == true: 
		name = "Hold"
		$ColorRect.position = Vector2(aoeRange/-2,-10)
		$ColorRect.size = Vector2(aoeRange,20)
		$ColorRect.visible = true
		if damage != null:#单位攻击有范围持续的效果先判定一次攻击伤害
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes)
		if giveEffect[Global.Effect.DAMAGE] != Global.OFFEFFECT:#平常情况下的伤害类型范围持续效果
			$holdTimer.start(effTime[Global.Effect.DAMAGE])
			await get_tree().create_timer(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE],false).timeout
			queue_free()
	else: pass
		#await get_tree().create_timer(0.04,false).timeout
		#queue_free()
	pass
		
func _on_area_entered(area):
			#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):	else:#AOE
	if damage == null: 
		if damagerType == null: 
			Global.damage_Calu(area,Global.damCaluType.EFF,null,null,null,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
	else:
		Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
	if ifAoeHold == false: 
		if damagerType != null&&damagerType[0] == "skill":

			Global.damage_Calu(area,Global.damCaluType.EFF,null,null,null,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
		queue_free()
	pass
	
func _on_hold_timer_timeout():
	Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,null,["skill"],giveEffect,effValue,effTime,effTimes)
	pass

func reload():
	queue_free()
	pass 












