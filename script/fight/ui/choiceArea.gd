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
	position.y = Global.FightGroundY-(Global.STSData[soldier]["collBox"].y/2)-6
	#更新选择盒子尺寸#防止塔堆叠放置
	if Global.STSData[soldier]["type"] == "tower":#选塔位置
		colorBox.size = Global.STSData[soldier]["collBox"]
		colorBox.position = Global.STSData[soldier]["collBox"]/-2
		collLine.target_position = Vector2(Global.STSData[soldier]["collBox"].x*2,0)
		collLine.position = Vector2(-((Global.STSData[soldier]["collBox"].x*2)-(Global.STSData[soldier]["collBox"].x/2)),0)
		Global.towerArea.visible = true
		area = Global.towerArea
		which = Global.Tower
	if Global.STSData[soldier]["type"] == "skill":#选技能位置
		colorBox.size = Vector2(Global.STSData[soldier]["aoeRange"],Global.NormalAOERangeY)
		colorBox.position = Vector2(Global.STSData[soldier]["aoeRange"]/-2,Global.NormalAOERangeY/-2)
		collLine.collide_with_areas = false
		Global.skillArea.visible = true
		area = Global.skillArea
		which = Global.Skill
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
		area.visible = false
		Global.NowMoney -= Global.STSData[soldier]["price"]
		card.button_mask = MOUSE_BUTTON_MASK_LEFT#恢复购买
		card.material = null
		card.buyCardReSet()
		Global.CardBuy = null
		queue_free()
	if area == Global.towerArea:
		if collLine.is_colliding():  colorBox.color = warnColor
		else:  colorBox.color = choiceColor
	pass



