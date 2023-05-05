extends Area2D
var kind = Global.Type.SKILL

var projectile
var proMode
var proRange

var aoeModel
var aoeRange
var aoeTime
var aoeTimes

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
	pass

func _process(_delta):
	pass

func firstsetting():
	collision_mask = Global.LAyer[aoeModel][0]
	if aoeTime != 0: 
		if damagerType == true: 
			$ColorRect.position = Vector2(aoeRange/-2,-10)
			$ColorRect.size = Vector2(aoeRange,20)
			$ColorRect.visible = true
		if damage != null: Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel,aoeRange,0,null,attackType,damage,null,giveEffect,effValue,effTime,effTimes)
		#攻击aoe有滞留先进行一次攻击判定其余按滞留原版流程弄
		monitoring = false
		$holdTimer.start(aoeTime)
		await get_tree().create_timer(aoeTimes*aoeTime,false).timeout
		queue_free()
	else:
		var newRange = RectangleShape2D.new()#AOE范围
		newRange.size = Vector2(aoeRange,Global.NormalAOERangeY)
		if damagerType == true: newRange.size = Vector2(aoeRange,Global.SkillAOERangeY)
		$CollisionShape2D.shape = newRange
		await get_tree().create_timer(0.1,false).timeout
		queue_free()
	pass
#func TRvalue_caluORcreate(caluType,damager,target,projectile,proMode,proRange,ifAoeHold,aoeModel,aoeRange,damage,damagerType,giveEffect,giveEffGoodOrBad):

func _on_Node2D_body_entered(body):
	if damage != null: Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,null,attackType,damage,null,giveEffect,effValue,effTime,effTimes)
	if damage == null: Global.TRvalue_caluORcreate(Global.Calu.EFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,null,null,null,null,giveEffect,effValue,effTime,effTimes)
	queue_free()
	pass


func _on_hold_timer_timeout():
	Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,null,null,aoeModel,aoeRange,0,null,damagerType,giveEffect,effValue,effTime,effTimes)
	pass

func reload():
	queue_free()
	pass 
