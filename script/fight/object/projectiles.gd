extends Area2D
var camp
var type = "projectiles"
var startPos = position.x
var currentPos
var stop = 1
var done = false

var projectile = null
var proRange = 0
var proSpeed = 0
var proDir = Vector2(0,0)
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
	if projectile == "firework": $tail.emitting = true
	pass

func _process(_delta):
	position += proDir*proSpeed*stop*Global.GameSpeed#Vector2(camp,1)*
	currentPos = position.x
	if abs(currentPos - startPos) >= proRange&&proDir.y == 0: queue_free()#超过射程直接自己销毁
	if position.y >= Global.FightGroundY&&aoeRange != null:#落地物体
		position.y = Global.FightGroundY-20
		aoeCreate()
	if position.y <= Global.FightSkyY&&projectile == "firework":
		$Sprite2D.texture =  load("res://assets/objects/projectiles/fireworkV.png")
		proDir = Vector2(1,0)#火箭拐弯
		$tail.emitting = false
		pass
	if position.y < -20: 
		await get_tree().create_timer(3,false).timeout
		queue_free()#烟花飞出去销毁,让粒子释放完
	pass

func _on_area_entered(area):
	if aoeModel == null:#单体
		if done == false:
			done = true#防止单体打重叠在一起的单体变aoe
			Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,giveEffect,effValue,
			effTime,effTimes)
		#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):	
	else: aoeCreate()#AOE
	if ifPriece == false: 
		if projectile == "firework"&&done == false:#释放轨迹粒子延迟死亡
			done = true
			collision_mask = 0
			stop = 0
			$Sprite2D.visible = false
			await get_tree().create_timer(2,false).timeout
			queue_free()
		else: queue_free()
	pass 
	
func aoeCreate():
	match projectile:
		"tnt","fireBall","fireBallDown": damagerType[0] = projectile#击中敌人有音效的弹射物
	if done == false:
		done = true
		Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,attackType,damage,
		damagerType,giveEffect,effValue,effTime,effTimes)
	queue_free()
	pass
	
func reload(): queue_free()




