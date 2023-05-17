extends Node2D
var soldier
var card
var area
var which
@export var choiceColor:Color
@export var warnColor:Color
@onready var colorBox = $ColorRect
@onready var collLine = $RayCast2D

func _ready(): 
	colorBox.color = choiceColor
	Global.FightSence.reloadSence.connect(reload)
	#Global.towerArea.visible = true
	#collLine.collision_mask = Global.MAsk[0][2]
	#$ColorRect.set_anchors_preset(PRESET_CENTER)
	pass
	
func reload():
	queue_free()
	pass

func _process(_delta):
	$RayCast2D.force_raycast_update()
	position.x = get_global_mouse_position().x
	position.x = clamp(position.x,area.position.x-colorBox.position.x,area.position.x+area.size.x+colorBox.position.x)
	if Input.is_action_just_pressed("ui_mouse_left")&&!collLine.is_colliding()&&Global.StopON == false:
		var friend = which.instantiate()
		Global.root.add_child(friend)
		friend.camp = Global.VILLAGE
		friend.firstSetting(soldier)
		friend.position.x = global_position.x
		friend.position.y = Global.FightGroundY+Global.STSData[soldier]["collBox"].y
		area.visible = false
		Global.NowMoney -= Global.STSData[soldier]["price"]
		card.button_mask = MOUSE_BUTTON_MASK_LEFT#恢复购买
		queue_free()
	if area == Global.towerArea:
		if collLine.is_colliding():  colorBox.color = warnColor
		else:  colorBox.color = choiceColor
	pass



