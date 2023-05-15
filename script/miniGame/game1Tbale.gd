extends AnimatedSprite2D
var last
var stop = false
var no = true

func _ready():
	Global.MiniGameSence.GameStart.connect(start)
	Global.MiniGameSence.Game1All.connect(all)
	pass


func _process(_delta):
	pass
	
func start():
	$moveTimer.start(randi_range(Global.MiniGame1RandMin,Global.MiniGame1RandMax))
	pass

func _on_move_timer_timeout():
	no = false
	var rand = randi_range(1,Global.MiniGame1RandGunpowder)
	#var rand = 5
	if rand == 1: play("powderShow")
	else: play("creeperShow")
	pass

func all():
	if no == true:
		$moveTimer.stop()
		play("creeperShow")
	pass

func _on_animation_finished():
	match animation:
		"creeperShow","powderShow":
			stop = true
			$holdTimer.start(Global.MiniGame1HoldTime)
	match animation:
		"creeperOut","powderOut","creeperDeath","powderDeath":
			no = true
			$moveTimer.start(randi_range(Global.MiniGame1RandMin,Global.MiniGame1RandMax))
	pass 

func _on_hold_timer_timeout():
	match animation:
		"creeperShow": play("creeperOut")
		"powderShow": play("powderOut")
	stop = false
	pass

func _on_area_2d_input_event(_viewport,event,_shape_idx):
	if event.is_action_pressed("ui_mouse_left")&&stop == true:
		$holdTimer.stop()
		match animation:
			"creeperShow":
				Global.MiniGameScore += 1
				play("creeperDeath")
			"powderShow":
				play("powderDeath")
				Global.MiniGameSence.emit_signal("Game1All")
				pass
		pass

	pass
