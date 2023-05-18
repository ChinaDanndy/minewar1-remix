extends Area2D
#const MAsk = [[1+16,1+4+16,16],[1+2+16+32],[2+32,2+8+32,32]]
const Mod = {"village":0,"all":1,"monster":2} 
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
	collision_mask = Global.MAsk[Mod[aoeModel]][0]
	var newRange = RectangleShape2D.new()#AOE范围
	newRange.size = Vector2(aoeRange,Global.NormalAOERangeY)
	if damagerType !=null:
		match damagerType[0]:
			"skill": newRange.size = Vector2(aoeRange,Global.SkillAOERangeY)#换范围
			"thunder": 
				var thunder = load("res://assets/objects/skill/thunder.png")
				newRange.size = thunder.get_size()
			"thunderBoss": 
				var thunder = load("res://assets/objects/skill/thunderBoss.png")
				newRange.size = thunder.get_size()
	$CollisionShape2D.shape = newRange
	if ifAoeHold == true: 
		if damagerType[0] == "skill":
			$ColorRect.position = Vector2(aoeRange/-2,-10)
			$ColorRect.size = Vector2(aoeRange,20)
			$ColorRect.visible = true
		if damage != null:#单位攻击有范围持续的效果先判定一次攻击伤害
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,attackType,damage,damagerType,
			giveEffect,effValue,effTime,effTimes)
		if giveEffect[Global.Effect.DAMAGE] != Global.OFFEFFECT:#平常情况下的伤害类型范围持续效果
			$holdTimer.start(effTime[Global.Effect.DAMAGE])
			#$deathTimer.start(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE])
		await get_tree().create_timer(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE],false).timeout
		queue_free()
	else:
		await get_tree().create_timer(0.04,false).timeout
		queue_free()
	pass

func _on_area_entered(area):
	if damage == null:
		Global.damage_Calu(area,Global.damCaluType.EFF,null,null,null,giveEffect,
		effValue,effTime,effTimes,Global.IfAoeType.NONE)#纯效果
	else:
		if ifAoeHold == false:
			Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,
			giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)#攻击全部
	if ifAoeHold == false:  queue_free()
	pass
	
func _on_hold_timer_timeout():
	Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,null,
	["skill"],giveEffect,effValue,effTime,effTimes)
	pass

func reload():
	queue_free()
	pass 















