extends Area2D
var kind = Global.Type.SKILL

var projectile
var proMode
var proRange

var ifAoeHold
var aoeModel
var aoeRange

var attackType
var damagerType
var damage
var giveEffect


func _ready():
	$ColorRect.visible = false
	Global.FightSence.reloadSence.connect(reload)
	pass

func _process(_delta):
	pass

func firstsetting():
	collision_mask = Global.LAyer[aoeModel][0]
	if ifAoeHold == true: 
		if damagerType == true: 
			$ColorRect.position = Vector2(aoeRange/-2,-10)
			$ColorRect.size = Vector2(aoeRange,20)
			$ColorRect.visible = true
		if damage != null: Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,false,aoeModel,aoeRange,attackType,damage,null,giveEffect)
		#攻击aoe有滞留先进行一次攻击判定其余按滞留原版流程弄
		monitoring = false
		$holdTimer.start(Global.EffTime)
		await get_tree().create_timer(Global.EffTime*Global.HoldEffectTimes,false).timeout
		queue_free()
	else:
		var newRange = RectangleShape2D.new()#AOE范围
		newRange.size = Vector2(aoeRange,20)
		if damagerType == true: newRange.size = Vector2(aoeRange,300)
		$CollisionShape2D.shape = newRange
		await get_tree().create_timer(0.1,false).timeout
		queue_free()
	pass
#func TRvalue_caluORcreate(caluType,damager,target,projectile,proMode,proRange,ifAoeHold,aoeModel,aoeRange,damage,damagerType,giveEffect,giveEffGoodOrBad):

func _on_Node2D_body_entered(body):
	if damage != null: Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,attackType,damage,null,giveEffect)
	if damage == null: Global.TRvalue_caluORcreate(Global.Calu.EFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,null,null,null,giveEffect)
	queue_free()
	pass


func _on_hold_timer_timeout():
	Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,false,aoeModel,aoeRange,null,null,damagerType,giveEffect)
	pass

func reload():
	queue_free()
	pass 
