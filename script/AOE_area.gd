extends Area2D
var kind = Global.Type.SKILL

var projectile
var proMode
var proRange

var ifAoeHold
var aoeModel
var aoeRange

var damageMethod
var attacks
var damagerType
var damage
var giveEffect
var giveEffGoodOrBad


func _ready():
	pass

func _process(_delta):
	pass

func firstsetting():
	#position = Vector2(200,200)
	collision_layer = 0
	collision_mask = Global.LAyer[aoeModel][0]
	if ifAoeHold == true: 
		monitoring = false
	else:
		var newRange = RectangleShape2D.new()#AOE范围
		newRange.size = Vector2(aoeRange,10)
		$CollisionShape2D.shape = newRange
	
	#滞留设定
	if ifAoeHold == true:
		$holdTimer.start(Global.EffTime)
		await get_tree().create_timer(Global.EffTime*Global.HoldEffectTimes,false).timeout
		queue_free()
	pass
#func TRvalue_caluORcreate(caluType,damager,target,projectile,proMode,proRange,ifAoeHold,aoeModel,aoeRange,damageMethod,attacks,damage,damagerType,giveEffect,giveEffGoodOrBad):

func _on_Node2D_body_entered(body):
	if projectile == null:
		Global.TRvalue_caluORcreate(Global.Calu.EFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,null,null,null,null,giveEffect,giveEffGoodOrBad)
	else:#弹射物滞留效果是先执行一次伤害判定再生成滞留效果生成点
		Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,damageMethod,attacks,damage,damagerType,giveEffect,giveEffGoodOrBad)
	if ifAoeHold == true:
		Global.TRvalue_caluORcreate(null,null,Global.TRtype.VALCREATE,null,null,ifAoeHold,null,null,null,null,null,null,null,giveEffect,giveEffGoodOrBad)
		ifAoeHold = false
	if ifAoeHold == false: queue_free()
	pass


func _on_hold_timer_timeout():
	Global.TRvalue_caluORcreate(null,null,Global.TRtype.VALCREATE,null,null,null,false,aoeModel,aoeRange,null,null,null,null,giveEffect,giveEffGoodOrBad)
	pass
