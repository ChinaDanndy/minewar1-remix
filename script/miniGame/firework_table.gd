extends Area2D
var firework = preload("res://sence/miniGame/firework.tscn")

func _ready():
	$fireworkHas.visible = true
	$fireworkNo.visible = false
	pass

func _process(_delta):
	
	pass

func _on_input_event(_viewport,event,_shape_idx):
	if event.is_action_pressed("ui_mouse_left")&&$fireworkHas.visible == true:
		var newFirework = firework.instantiate()
		Global.root.add_child(newFirework)
		newFirework.position = position
		$fireworkHas.visible = false
		$fireworkNo.visible = true
		$reloadTimer.start(Global.MiniGame2FireworkReloadTime)
		pass
	pass


func _on_reload_timer_timeout():
	$fireworkHas.visible = true
	$fireworkNo.visible = false
	pass
