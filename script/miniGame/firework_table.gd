extends Area2D
var firework = preload("res://sence/miniGame/firework.tscn")
var reloadTime = Global.LevelData[0]["miniGame2"]["reloadTime"]

func _ready():
	$fireworkHas.visible = true
	$fireworkNo.visible = false
	pass
func _process(_delta): $AudioStreamPlayer.volume_db = Global.SeDB

func _on_input_event(_viewport,event,_shape_idx):
	if event.is_action_pressed("ui_mouse_left")&&$fireworkHas.visible == true:
		$AudioStreamPlayer.play()
		var newFirework = firework.instantiate()
		Global.root.add_child(newFirework)
		newFirework.position = position
		$fireworkHas.visible = false
		$fireworkNo.visible = true
		await get_tree().create_timer(reloadTime,false).timeout
		$fireworkHas.visible = true
		$fireworkNo.visible = false
		#$reloadTimer.start(Global.MiniGame2FireworkReloadTime)
	pass

func _on_reload_timer_timeout():
	$fireworkHas.visible = true
	$fireworkNo.visible = false
	pass
