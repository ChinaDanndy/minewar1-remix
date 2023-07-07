extends CanvasLayer
var Mode
var soundOnce = true

func _process(_delta): 
	$click.volume_db = Global.SeDB
	$lose.volume_db = Global.SeDB
	$win.volume_db = Global.SeDB
	pass

func text(mode):
	get_tree().paused = true
	Mode = mode
	match mode:
		"stop": $Control/Title.text = "暂停"
		"win": 
			if soundOnce == true: $win.play()
			$Control/Title.text = "胜利"
			if get_parent().name == "Fight"&&Global.NowLevel == Global.Level:
				if Global.Level<=6: $Control/card.visible = true
				if Global.Level<7: addPoint()
			if get_parent().name == "MiniGame": addPoint()
		"lose": 
			if soundOnce == true: $lose.play()
			$Control/Title.text = "失败"
			$Control/HBoxContainer/Button2.visible = false
	if get_parent().name == "MiniGame":
		match Mode:
			"win","lose": $Control/HBoxContainer/Button2.visible = false
	Global.StopWindow.visible = true
	soundOnce = false
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
	$Control/card.visible = false
	$Control/emerald.visible = false
	if get_parent().name == "MiniGame": $Control/card.free()
	pass
