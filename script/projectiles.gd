extends Area2D
var camp
var type = Global.Type.PROJECTILE
var startPos = position.x
var currentPos
var frame

var father
var projectile
var proRange

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
var ifAoe

var Hdisplacement = 0
var Vdisplacement = 0
var target
var G = 0.5
var D = Vector2(1,-1)
var S = 2
var velocity = D*S

var time = 0
var timeAddValue = 0.1
func _ready():
	startPos = position.x
	father = get_parent()
	camp = father.camp
	collision_mask = father.collision_mask
	pass

func firstSetting():
	#S = round(sqrt((proRange.x*G)/abs(sin(Vector2(1,-1).angle()*cos(Vector2(1,-1).angle()))))/3)
	#velocity = D*S
	$Sprite2D.texture = load("res://assets/projectiles/"+projectile+".png")
	var newBox = RectangleShape2D.new()#碰撞箱自适应
	newBox.size = $Sprite2D.texture.get_size()
	$CollisionShape2D.shape = newBox
	if camp == Global.MONSTER: $Sprite2D.flip_h = true
	
#	if Global.ProTypeValue[projectile] == Global.ProType.FINAL: 
#		monitoring = false
#	else:
#		var collShape = RectangleShape2D.new()#各个子弹的碰撞箱
#		collShape.size = Global.ProShape[projectile]
#		$CollisionShape2D.shape = collShape
		
	if Global.ProPicture[projectile] > 1:
		$Sprite2D.hframes = Global.ProPicture[projectile]
		$Sprite2D.frame = 0
		$animationTimer.start(Global.ProAniTime[projectile])
		
	pass


func _process(_delta):
	#if	proMode == Global.ProMode.HTHROW:
		#position += velocity
		#velocity.y += G*G
	#else: 
	#if monitoring == false&&position.y>Global.FightGroundY:
		#match damageMethod:
			#Global.DamageMethod.AOE:#AOE伤害
				#pass
				#Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,projectile,null,null,ifAoeHold,aoeModel,aoeRange,null,attacks,null,damagerType,giveEffect,giveEffGoodOrBad)
		#queue_free()
	position += Vector2(camp,0)*Global.ProSpeed[projectile]*Global.ProDire[projectile]
	currentPos = position.x
	if (currentPos - startPos) >= proRange.x: queue_free()#超过射程直接自己销毁
	pass

func _on_body_entered(body):
	if aoeRange == 0:#单体
		Global.damage_Calu(body,Global.damCaluType.ATTEFF,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
		#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):	
	else:#AOE
		Global.aoe_create(body,Global.CREATE,aoeModel,aoeRange,ifAoeHold,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes)
	#if Global.ProTypeValue[projectile] != Global.ProType.PIERCE: 
	queue_free()
	pass


func _on_animation_timer_timeout():
	frame += 1 
	if $Sprite2D.frame != Global.ProPicture[projectile]:  $Sprite2D.frame += 1
	if frame == Global.ProPicture[projectile]+1: 
		frame = 0
		$Sprite2D.frame == 0
		
	pass 
	
