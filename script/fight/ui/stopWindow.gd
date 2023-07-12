extends CanvasLayer
var Mode

func _process(_delta): 
	$click.volume_db = Global.SeDB
	$lose.volume_db = Global.SeDB
	$win.volume_db = Global.SeDB
	pass

func text(mode):
	get_tree().paused = true
	$Control/thank.visible = false
	$Control/emerald.visible = false
	$Control/gameSpeed.visible = false
	if get_parent().name == "Fight": 
		$Control/card.visible = false
		$Control/miniGame.visible = false
	Mode = mode
	match mode:
		"stop": 
			if get_parent().name == "Fight": 
				$Control/gameSpeed/gameSpeedButton/value.text = str(Global.GameSpeed)
				$Control/gameSpeed.visible = true
			$Control/Title.text = "暂停"
		"win": 
			$win.play()
			$Control/Title.text = "胜利"
			if get_parent().name == "Fight":
				$Control/card.visible = false
				$Control/miniGame.visible = true
				$Control/miniGame/title.visible = false
				$Control/miniGame/game1.visible = false
				$Control/miniGame/game2.visible = false
				$Control/card/Unlock.visible = true
				$Control/card/CanBuy.visible = true
				if Global.NowLevel == Global.Level:
					if Global.Level<7: $Control/card.visible = true#新的解锁
					if Global.Level == 1||Global.Level == 4:#小游戏解锁展示
						$Control/miniGame/title.visible = true
					if Global.Level == 1: $Control/miniGame/game1.visible = true
					if Global.Level == 4: $Control/miniGame/game2.visible = true
					if Global.Level<8: addPoint()#加钱
				if Global.NowLevel == 9:#boss战结束
					$Control/HBoxContainer/Button2.visible = false
					if Global.Level == 8:#第一次打完boss感谢
						$Control/thank.visible = true
						Global.Level = 10
			if get_parent().name == "MiniGame": addPoint()#加钱
		"lose": 
			$lose.play()
			$Control/Title.text = "失败"
			$Control/HBoxContainer/Button2.visible = false
	if get_parent().name == "MiniGame":
		match Mode:
			"win","lose": $Control/HBoxContainer/Button2.visible = false
	Global.StopWindow.visible = true
	pass
	
func addPoint():
	if $Control/emerald.visible == false:
		if get_parent().name == "Fight": Global.Level += 1
		Global.Point+=1
		$Control/emerald.visible = true
		$Control/emerald/emeraldSquare/emeraldNumber.text = str(Global.Point)
	pass

func usual():
	$click.play()
	get_tree().paused = false
	$Control/HBoxContainer/Button1.button_pressed = false
	$Control/HBoxContainer/Button2.button_pressed = false
	$Control/HBoxContainer/Button3.button_pressed = false
	Global.StopWindow.visible = false
	pass

func _on_button_1_pressed():
	usual()
	get_tree().reload_current_scene()
	pass
	
func _on_button_2_pressed():
	usual()
	if Mode == "win": 
		Global.NowLevel += 1
		get_tree().reload_current_scene()
	pass 
	
func _on_button_3_pressed():
	usual()
	get_tree().change_scene_to_file("res://sence/start/Start.tscn")
	pass 

func _on_tree_entered():
	if get_parent().name == "MiniGame": 
		$Control/card.free()
		$Control/miniGame.free()
	pass

func _on_game_speed_button_pressed():
	match Global.GameSpeed:#游戏调速
		1: Global.GameSpeed = 1.25
		1.25: Global.GameSpeed = 0.5
		0.5: Global.GameSpeed = 0.75
		0.75: Global.GameSpeed = 1
	$Control/gameSpeed/gameSpeedButton/value.text = str(Global.GameSpeed)
	Engine.time_scale = Global.GameSpeed
	pass
