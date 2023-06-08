extends Area2D
var camp = 0
signal ProtectDown 
@export var AName:String
@onready var picture = get_parent()
@onready var healthColor = get_parent().get_node("healthLine/health/ColorRect")
var originSize
var effDefence = [true,true,true,true,false,false,true]
var attDefence = [false,false,false]
var type = "base"
var health = 5
var healthUp
var shield =0
var collBox

func firstSetting(Name):
	var newBox = RectangleShape2D.new()
	collBox = get_parent().texture.get_size()
	newBox.size = collBox
	$CollisionShape2D.shape = newBox
	get_parent().get_node("cover").texture = get_parent().texture
	get_parent().get_node("cover").visible = false
	get_parent().get_node("healthLine").position.y = (-collBox.y/2-16)
	if get_parent().name == "bossProtect": 
		health = Global.STSData["creeperKing"]["protectHealth"]
		get_parent().position.y = Global.FightSkyY
		get_parent().get_node("healthLine").visible = false
	else: 
		collision_layer = Global.LAyer[camp+1][2]
		health = Global.LevelData[Global.NowLevel]["set"][Name]
		get_parent().position.y = Global.FightGroundY-(collBox.y/2)
#		if get_parent().name == "baseMonster": 
#			match Global.LevelData[Global.NowLevel]["set"]["levelType"]:
#				"attack": get_parent().texture = load("res://assets/objects/attackNormal.png")
#				"defence": get_parent().texture = load("res://assets/objects/defence.png") 
	healthUp = health
	originSize = healthColor.size.x

	pass
	
func _ready():
	pass

func hurt():
	get_parent().get_node("cover").visible = true
	get_parent().get_node("hurt").playing = true
	await get_tree().create_timer(0.2,false).timeout
	get_parent().get_node("cover").visible = false
	pass
	
func _process(_delta):
	#if Input.is_action_just_pressed("ui_test"): print(health)
	
	healthColor.size.x = originSize*(health/healthUp)
	
	get_parent().get_node("Label").text = str(health)
	if get_parent().name == "bossProtect":
		if Input.is_action_just_pressed("ui_test"): 
			health = 0
		
		if health <= 0&&get_parent().visible == true:
			get_parent().visible = false
			collision_layer = 0
			emit_signal("ProtectDown")
	pass
	
