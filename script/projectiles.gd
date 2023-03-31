extends Area2D
var camp
var type = Global.Type.PROJECTILE
var startPos = position.x
var currentPos

var father

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


var target
var G = 0.1


func _ready():
	father = get_parent()
	camp = father.camp
	collision_mask = father.collision_mask
	collision_layer = 0
	pass

func firstSetting():
	$Sprite2D.texture = load("res://assets/projectiles/"+str(Global.ProName[projectile])+".png")
	if camp == Global.MONSTER: $Sprite2D.flip_h = true
	if Global.ProTypeValue[projectile] == Global.ProType.FINAL: 
		monitoring = false
	else:
		var collShape = RectangleShape2D.new()#各个子弹的碰撞箱
		collShape.size = Global.ProShape[projectile]
		$CollisionShape2D.shape = collShape
		
	if Global.ProPicture[projectile] > 1:
		$Sprite2D.hframes = Global.ProPicture[projectile]
		$Sprite2D.frame = 0
		$animationTimer.start(Global.ProAniTime[projectile])
	pass
	#动画图片间隔时间
#图片数量 碰撞框尺寸
func calu():
#	var D = abs(target.position.x - self.position.x)
#	var T = round(D/(target.speedBasic.x + velocity.x))-5
#	velocity.y = -(T*G)#抛物线
	pass

func _process(_delta):
#	position += velocity
#	velocity.y += G
	if proMode != Global.ProMode.ATHROW&&proMode != Global.ProMode.HTHROW:
		position += Vector2(camp,0)*Global.ProSpeed[projectile]*Global.ProModeValue[proMode]
	
#func TRvalue_caluORcreate(caluType,damager,target,projectile,proMode,proRange,ifAoeHold,aoeModel,aoeRange,damageMethod,attacks,damage,damagerType,giveEffect,giveEffGoodOrBad):

	currentPos = position.x
	if monitoring == false&&position.y>Global.FightGroundY:
		match damageMethod:
			Global.DamageMethod.AOE:#AOE伤害
				Global.TRvalue_caluORcreate(null,null,Global.TRtype.VALCREATE,projectile,null,null,ifAoeHold,aoeModel,aoeRange,damageMethod,attacks,damage,damagerType,giveEffect,giveEffGoodOrBad)
		queue_free()
		
	if (currentPos - startPos) >= proRange.x: queue_free()#超过射程直接自己销毁
	pass



func _on_body_entered(body):
	match damageMethod:
		Global.DamageMethod.SINGAL:#单体伤害
			Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,body,Global.TRtype.VALCALU,null,null,null,null,null,null,damageMethod,attacks,damage,damagerType,giveEffect,giveEffGoodOrBad)
		Global.DamageMethod.AOE:#AOE伤害
			Global.TRvalue_caluORcreate(null,null,Global.TRtype.VALCREATE,projectile,null,null,ifAoeHold,aoeModel,aoeRange,damageMethod,attacks,damage,damagerType,giveEffect,giveEffGoodOrBad)
		
	if Global.ProTypeValue[projectile] != Global.ProType.PIERCE:  queue_free()
	pass 


func _on_animation_timer_timeout():
	$Sprite2D.frame += 1
	if $Sprite2D.frame >= Global.ProPicture[projectile]: $Sprite2D.frame == 0
	pass 
