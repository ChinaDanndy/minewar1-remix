extends CharacterBody2D
var camp
var type = Global.Type.BASE
var Name
var health
var healthUp
var collBox:Vector2##不用记录根据已读入数据推算

var nowEffect = [0,0,0,0,0,0,0,0]
var effDefence = [true,true,true,false,false,true]

var shield = 0
var attDefence = [false,false,false]

var damageBasic = 0
var speedBasic = 0
var attRangeBasic = 0
var aniSpeedBasic = 0

func firstSetting(Name):
	health = Global.LevelData[Global.Level][0][Name]
	healthUp = health
	collision_layer = Global.LAyer[camp+1][2]
	var newBox = RectangleShape2D.new()
	collBox = get_parent().texture.get_size()
	newBox.size = collBox
	$CollisionShape2D.shape = newBox
	pass


func _physics_process(_delta):
	get_parent().get_node("Label").text = str(health)
	pass
