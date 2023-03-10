extends Area2D
var kind = Global.Type.SKILL

var ifProPierce
var damageMethod
var proRange
var aoeModel
var aoeRange
var ifAoeHold
var attackType
var damagerType
var damage
var giveEffect
var giveEffGoodOrBad

func _ready():
	pass

func _process(delta):
	
	
	pass

func firstsetting():
	#position = Vector2(200,200)
	collision_layer = 0
	collision_mask = Global.LAyer[aoeModel][0]
	var newRange = RectangleShape2D.new()#AOE范围
	newRange.size = Vector2(aoeRange,10)
	$CollisionShape2D.shape = newRange
	
	#滞留设定
	if ifAoeHold == true:
		await get_tree().create_timer(Global.EffTime*Global.HoldEffectTimes).timeout
		queue_free()
	pass

func _on_Node2D_body_entered(body):
	if ifProPierce == null:
		Global.TRvalue_caluORcreate(Global.Calu.EFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,null,null,null,giveEffect,giveEffGoodOrBad)
	else:
		Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,attackType,damagerType,damage,giveEffect,giveEffGoodOrBad)
		Global.TRvalue_caluORcreate(Global.Calu.EFF,body,Global.TRtype.VALCALU,null,null,null,null,null,true,null,null,null,giveEffect,giveEffGoodOrBad)
	if ifAoeHold == false: queue_free()
	pass
