extends Area2D
var camp
var type = "projectiles"
var startPos = position.x
var currentPos
var voice
var frame
var stop = 1

var father 
var projectile = null
var proRange = Vector2(0,0)
var proSpeed = 0
var ifPriece = false

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
	startPos = position.x
	$Sprite2D.texture = load("res://assets/objects/projectiles/"+projectile+".png")
	var newBox = RectangleShape2D.new()#碰撞箱自适应
	newBox.size = $Sprite2D.texture.get_size()
	$CollisionShape2D.shape = newBox
	if camp == Global.MONSTER: $Sprite2D.flip_h = true
	if Global.ProPicture[projectile] > 1:
		$Sprite2D.hframes = Global.ProPicture[projectile]
		$Sprite2D.frame = 0
		$animationTimer.start(Global.ProAniTime[projectile])
	pass

func _process(_delta):
	position += Vector2(camp,1)*Global.ProDire[projectile]*proSpeed*stop
	currentPos = position.x
	if (currentPos - startPos) >= proRange: queue_free()#超过射程直接自己销毁
	if position.y > Global.FightGroundY:#落地物体
		position.y = Global.FightGroundY-20
		Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,attackType,damage,damagerType,
		giveEffect,effValue,effTime,effTimes)
		queue_free()
	pass

func _on_area_entered(area):
	if aoeModel == null:#单体
		Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,giveEffect,effValue,
		effTime,effTimes,Global.IfAoeType.NONE)
		#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):	
	else:#AOE
		match projectile:
			"tnt","fireBall","fireBallDown": damagerType[0] = projectile
		Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,attackType,damage,damagerType,
		giveEffect,effValue,effTime,effTimes)
	if ifPriece == false: queue_free()
	pass 


func _on_animation_timer_timeout():
	frame += 1 
	if $Sprite2D.frame != Global.ProPicture[projectile]:  $Sprite2D.frame += 1
	if frame == Global.ProPicture[projectile]+1: 
		frame = 0
		$Sprite2D.frame = 0
	pass 
	
func reload():
	queue_free()
	pass 
	



