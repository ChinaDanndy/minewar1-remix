extends Area2D
var soldier
var available = true
func _ready():
	Global.towerArea.visible = true
	collision_mask = Global.MAsk[2][0]
	pass


func _process(_delta):
	position.x = get_global_mouse_position().x
	position.x = clamp(position.x,Global.towerArea.position.x,Global.towerArea.position.x+Global.towerArea.size.x)
	if Input.is_action_just_pressed("ui_mouse_left"):
		var friend = Global.Soldier.instantiate()
		Global.root.add_child(friend)
		friend.firstSetting(soldier)
		friend.position.x = position.x
		friend.position.y = 297
		Global.towerArea.visible = false
		queue_free()
	pass

func _on_body_entered(body):
	available = false
	pass

func _on_body_exited(body):
	available = true
	pass
