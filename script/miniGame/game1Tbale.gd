extends AnimatedSprite2D
var last
var stop = false
var no = true
var allTime = false

var GoodRand = Global.LevelData[0]["miniGame1"]["gunpowderRand"]
var Show = Global.LevelData[0]["miniGame1"]["show"]
var GoodOn = 0
var Min = Global.LevelData[0]["miniGame1"]["timeRand"]["Min"]
var Max = Global.LevelData[0]["miniGame1"]["timeRand"]["Max"]
var Cut = Global.LevelData[0]["miniGame1"]["timeRand"]["Cut"]
var CutOn = 0

func _ready():
	Global.MiniGameSence.GameStart.connect(start)
	Global.MiniGameSence.Game1All.connect(all)
	Global.MiniGameSence.Game1First.connect(firstSet)
	Global.MiniGameSence.Game1Last.connect(lastSet)
	pass

func _process(_delta): 
	$normal.volume_db = Global.SeDB
	$well.volume_db = Global.SeDB
func start(): $moveTimer.start(randi_range(Min,Max))
func _on_move_timer_timeout():
	no = false
	var showNumber = randi_range(1,Show)
	var rand = randi_range(1,GoodRand)*GoodOn
	if showNumber == 1:
		if rand == 1: play("powderShow")
		else: play("creeperShow")
	else: 
		$moveTimer.start(randf_range(Min-(Cut*CutOn),Max-(Cut*CutOn)))
		no = true
	pass

func all():
	if no == true:
		$moveTimer.stop()
		play("creeperShow")
		allTime = true
	pass
func firstSet(): GoodOn = 1
func lastSet(): CutOn = 1

func _on_animation_finished():
	match animation:
		"creeperShow","powderShow":
			stop = true
			$holdTimer.start(randf_range(0.75,1))
			if allTime == true:
				$holdTimer.start(1.4)
				allTime = false
	match animation:
		"creeperOut","powderOut","creeperDeath","powderDeath":
			no = true
			$moveTimer.start(randf_range(Min-(Cut*CutOn),Max-(Cut*CutOn)))
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
				$clickNormal.emitting = true
				$normal.play()
				Global.MiniGameScore += 1
				play("creeperDeath")
			"powderShow":
				$clickWell.emitting = true
				$well.play()
				play("powderDeath")
				Global.MiniGameSence.emit_signal("Game1All")
	pass
