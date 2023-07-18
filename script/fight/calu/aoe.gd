extends Area2D
#const MAsk = [[1+16,1+4+16,16],[1+2+16+32],[2+32,2+8+32,32]]
var type = "aoe"
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
	match damagerType[0]:
		"regeneration","power","ice","regenerationDo","weakness":#
			collision_mask = Global.MAsk[Mod[aoeModel]][3]#药水碎了的声音
			if damagerType[0] != "regenerationDo":
				$se/broke.volume_db = Global.SeDB
				$se/broke.play()
		"fireBall","fireBallDown":#爆炸声音
			$se/explode.volume_db = Global.SeDB
			$se/explode.play()
	match damagerType[0]:
		"fireBall","fireBallDown": $particles/fireballExplode.emitting = true
	match damagerType[0]:#粒子
		"regeneration": $particles/regeneration.emitting = true
		"power":  $particles/power.emitting = true
		"weakness":  $particles/weakness.emitting = true
		"ice": $particles/ice.emitting = true
		"firework":
			$se/firework.volume_db = Global.SeDB
			$se/firework.play()
			$particles/fireworkExplode.emitting = true
		"tnt": 
			$se/broke.volume_db = Global.SeDB
			$se/broke.play()
			$particles/damage.emitting = true
		"thunder": 
			collision_mask = 1+4+8+16
			newRange.size.y = Global.STSData["thunder"]["collBox"].y
			$se/thunder.volume_db = Global.SeDB
			$se/thunder.play()
		"crpeerKingExplode": 
			collision_mask = 1+2+4+8+16
			newRange.size.y = 600 
	$CollisionShape2D.shape = newRange
	if ifAoeHold == true: 
		if damage != null:#单位攻击有范围持续的效果先判定一次攻击伤害
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,attackType,damage,damagerType,
			giveEffect,effValue,effTime,effTimes)
		if giveEffect[Global.Effect.DAMAGE] != Global.OFFEFFECT:#平常情况下的伤害类型范围持续效果
			$holdTimer.start(effTime[Global.Effect.DAMAGE])
		await get_tree().create_timer(effTime[Global.Effect.DAMAGE]*effTimes[Global.DamValue.DAMAGE],false).timeout
		queue_free()
	else:
		if damagerType[0] == "power"||damagerType[0] == "weakness"||(
			damagerType[0] == "thunder")||damagerType[0] == "tnt"||(
			damagerType[0] == "fireBall")||damagerType[0] == "fireBallDown"||(
			damagerType[0] == "ice")||damagerType[0] == "firework":
			await get_tree().create_timer(0.1,false).timeout
			collision_mask = 0
			await get_tree().create_timer(0.8,false).timeout
			queue_free()
		else:
			await get_tree().create_timer(0.1,false).timeout
			queue_free()
	pass

func _on_area_entered(area):
	
	if damage == null:
		Global.damage_Calu(area,Global.damCaluType.EFF,null,null,null,giveEffect,
		effValue,effTime,effTimes)#纯效果
	else:
		Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,
		giveEffect,effValue,effTime,effTimes)#攻击全部
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















