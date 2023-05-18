extends Area2D
var camp = 0
signal ProtectDown 
@export var AName:String
@onready var picture = get_parent()
var effDefence = [true,true,true,false,false,true]
var attDefence = [false,false,false]
var type
var health = 5
var healthUp
var shield =0
var collBox

func firstSetting(Name):
	AName = Name
	type = "base"
	#health = Global.LevelData[Global.Level][0][Name]
	print(name)
	health = 5
	healthUp = health
	collision_layer = Global.LAyer[camp+1][2]
	
	var newBox = RectangleShape2D.new()
	collBox = get_parent().texture.get_size()
	newBox.size = collBox
	$CollisionShape2D.shape = newBox

	pass
	
func _ready():
	if get_parent().name == "bossProtect": 
		print("aaaaa")
		get_parent().visible = false
		monitorable = false

	pass


func _process(_delta):
	get_parent().get_node("Label").text = str(health)
	
		
	if get_parent().name == "bossProtect":
		if Input.is_action_just_pressed("ui_test"):
			health = 0

		if health <= 0&&get_parent().visible == true:
			get_parent().visible = false
			monitorable = false
			emit_signal("ProtectDown")

	pass
