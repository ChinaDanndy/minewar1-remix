extends Area2D
var camp
var type = "projectiles"
var startPos = position.x
var currentPos
#var voice
#var frame
#var father 

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
	pass

func _process(_delta):
	position += proDir*proSpeed#Vector2(camp,1)*
	currentPos = position.x
	if abs(currentPos - startPos) >= proRange&&proDir.y == 0: queue_free()#超过射程直接自己销毁
	if position.y >= Global.FightGroundY&&aoeRange != null:#落地物体
		position.y = Global.FightGroundY-20
		aoeCreate()
		queue_free()
	pass

func _on_area_entered(area):
	if aoeModel == null:#单体
		Global.damage_Calu(area,Global.damCaluType.ATTEFF,attackType,damage,damagerType,giveEffect,effValue,
		effTime,effTimes)
		#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):	
	else:aoeCreate()#AOE
	if ifPriece == false: queue_free()
	pass 
	
func aoeCreate():
	match projectile:
		"tnt","fireBall","fireBallDown": damagerType[0] = projectile#击中敌人有音效的弹射物
	Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,attackType,damage,
	damagerType,giveEffect,effValue,effTime,effTimes)
	pass
	
func reload(): queue_free()




