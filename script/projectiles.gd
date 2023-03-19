extends CharacterBody2D
var camp
var type = Global.Type.PROJECTILE
var startPos = position.x
var currentPos

var father
var other

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

var target

var G = 0.1


func _ready():
	father = get_parent()
	collision_mask = father.collision_mask
	camp = father.camp
	
	collision_layer = 0
	$RayCast2D.collision_mask = collision_mask
	$RayCast2D.position = Vector2(0,0)
	$RayCast2D.target_position = Vector2(10*camp,0)
	pass

func calu():
	
#	var D = abs(target.position.x - self.position.x)
#	var T = round(D/(target.speedBasic.x + velocity.x))-5
#	velocity.y = -(T*G)#抛物线
	pass

func _process(delta):
	$RayCast2D.force_raycast_update()
	if $RayCast2D.is_colliding():
		other = $RayCast2D.get_collider()
		match damageMethod:
			Global.DamageMethod.SINGAL:#单体伤害
				Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,other,Global.TRtype.VALCALU,null,null,null,null,null,null,attackType,damage,damagerType,giveEffect,giveEffGoodOrBad)
			Global.DamageMethod.AOE:#AOE伤害
				Global.TRvalue_caluORcreate(null,other,Global.TRtype.VALCREATE,ifProPierce,null,null,aoeModel,aoeRange,ifAoeHold,attackType,damage,damagerType,giveEffect,giveEffGoodOrBad)
		
		if ifProPierce == false:  queue_free()

#	position += velocity
#	velocity.y += G
	position += Vector2(3*camp,0)
	currentPos = position.x
	if (currentPos - startPos) >= proRange.x: queue_free()#超过射程直接自己销毁
	pass

