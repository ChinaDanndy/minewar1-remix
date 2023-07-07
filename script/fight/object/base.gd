extends Area2D
var camp = 0
signal ProtectDown 
@export var AName:String
@onready var picture = get_parent()
#@onready var bossProctectShow = get_parent()
@onready var healthColor = get_parent().get_node("healthLine/Sprite2D")
var originSize
var effDefence = [true,true,true,true,false,false,true]
var attDefence = [false,false,false]
var type = "base"
var health = 5
var healthUp
var shield =0
var collBox

func firstSetting(Name):
	if get_parent().name == "bossProtect": 
		health = Global.STSData["creeperKing"]["protectHealth"]
		get_parent().position.y = Global.FightSkyY
		get_parent().position.x = Global.BossPosX+60
		get_parent().get_node("healthLine").visible = false
		get_parent().get_node("hurt").stream = load("res://assets/music/se/soldier/hurt1.ogg")
		attDefence = [false,false,true]
	else: 
		collision_layer = Global.LAyer[camp+1][2]
		health = Global.LevelData[Global.NowLevel]["set"][Name]
		if get_parent().name == "baseMonster": 
			match Global.LevelData[Global.NowLevel]["set"]["levelType"]:
				"defence": 
					get_parent().get_node("healthLine").visible = false
					get_parent().texture = load("res://assets/objects/defence.png") 
					effDefence = [true,true,true,true,true,true,true]
					attDefence = [true,true,true]
	var newBox = RectangleShape2D.new()
	collBox = get_parent().texture.get_size()
	newBox.size = collBox
	$CollisionShape2D.shape = newBox
	if !get_parent().name == "bossProtect": 
		get_parent().position.y = Global.FightGroundY-(collBox.y/2)
		
	healthUp = health
	originSize = healthColor.texture.get_size().x
	get_parent().get_node("cover").texture = get_parent().texture
	get_parent().get_node("cover").visible = false
	get_parent().get_node("healthLine").position.y = (-collBox.y/2-16)
	pass

func hurt():
	get_parent().get_node("cover").visible = true
	get_parent().get_node("hurt").playing = true
	await get_tree().create_timer(0.2,false).timeout
	get_parent().get_node("cover").visible = false
	pass
	
func _process(_delta):
	#if Input.is_action_just_pressed("ui_test"): print(health)
	if health >0:
		healthColor.region_rect = Rect2(0,0,originSize*(health/healthUp),10)
		healthColor.position.x = -((originSize-(originSize*(health/healthUp)))/2)
	else: healthColor.region_rect =  Rect2(0,0,0,0)
		
	get_parent().get_node("Label").text = str(health)
	if get_parent().name == "bossProtect":
		if Input.is_action_just_pressed("ui_test"): 
			health = 0
		
		if health <= 0&&get_parent().visible == true:
			get_parent().visible = false
			Global.BossSkill.visible = false
			collision_layer = 0
			emit_signal("ProtectDown")
	pass
	
