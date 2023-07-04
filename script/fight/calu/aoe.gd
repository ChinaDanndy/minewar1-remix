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
	Global.FightSence.reloadSence.connect(reload)
	collision_mask = Global.MAsk[Mod[aoeModel]][0]
	var newRange = RectangleShape2D.new()#AOE范围
	newRange.size = Vector2(aoeRange,20)
#	if damagerType[0] == "regenerationDo":#防御塔不能回血
#		collision_mask = Global.MAsk[Mod[aoeModel]][3]
	match damagerType[0]:
		"regeneration","power","weakness","tnt","ice","regenerationDo":
			collision_mask = Global.MAsk[Mod[aoeModel]][3]
			if damagerType[0] != "regenerationDo":
				$se/broke.volume_db = Global.SeDB
				$se/broke.play()
		"fireBall","fireBallDown":
			$se/explode.volume_db = Global.SeDB
			$se/explode.play()
	match damagerType[0]:
		"fireBall","fireBallDown": $particles/fireballExplode.emitting = true
	match damagerType[0]:
		"regeneration": $particles/regeneration.emitting = true
		"power":  $particles/power.emitting = true
		"weakness":  $particles/weakness.emitting = true
		"ice": $particles/ice.emitting = true
		"tnt": 
			collision_mask = Global.MAsk[Mod[aoeModel]][0]
			$particles/tntExplode.emitting = true
		"thunder": 
			newRange.size.y = Global.STSData["thunder"]["collBox"].y
			$se/thunder.volume_db = Global.SeDB
			$se/thunder.play()
		"crpeerKingExplode": newRange.size.y = 600 

#	match projectile:
#		"fireBall","fireBallDown":
#			$particles/fireballExplode.emitting = true
#			$se/fireballExplode.play()
#	if projectile == "tnt":
#		$particles/tntExplode.emitting = true
#		$se/tntExplode.play()
##			"skill": newRange.size = Vector2(aoeRange,Global.SkillAOERangeY)#换范围
#			"thunderBoss": 
#				var thunder = load("res://assets/objects/skill/thunderBoss.png")
#				newRange.size = thunder.get_size()
	$CollisionShape2D.shape = newRange
	if ifAoeHold == true: 
		if damage != null:#单位攻击有范围持续的效果先判定一次攻击伤害
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,attackType,damage,damagerType,
			giveEffect,effValue,effTime,effTimes)
		if giveEffect[Global.Effect.DAMAGE] != Global.OFFEFFECT:#平常情况下的伤害类型范围持续效果
			$holdTimer.start(effTime[Global.Effect.DAMAGE])
			#$deathTimer.start(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE])
		await get_tree().create_timer(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE],false).timeout
		queue_free()
	else:
		if damagerType[0] == "power"||damagerType[0] == "weakness"||(
			damagerType[0] == "thunder")||damagerType[0] == "tnt"||(
			damagerType[0] == "fireBall")||damagerType[0] == "fireBallDown"||(
			damagerType[0] == "ice"):
			await get_tree().create_timer(0.04,false).timeout
			collision_mask = 0
			await get_tree().create_timer(0.8,false).timeout
			queue_free()
		else:
			await get_tree().create_timer(0.04,false).timeout
			queue_free()
	pass

func _on_area_entered(area):
	if ifAoeHold == false:
		if damage == null:
			Global.damage_Calu(area,Global.damCaluType.EFF,null,null,null,giveEffect,
			effValue,effTime,effTimes)#纯效果
		else:
			Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,
			giveEffect,effValue,effTime,effTimes)#攻击全部
		#queue_free()
	pass
	
func _on_hold_timer_timeout():
	var new
	if giveEffect[Global.Effect.DAMAGE]  == Global.EFFGOOD: new = "regenerationDo"
	Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,null,
	[new],giveEffect,effValue,effTime,effTimes)
	pass

func reload():
	queue_free()
	pass 















