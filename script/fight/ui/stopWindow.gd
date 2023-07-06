extends CanvasLayer
var Mode
func _ready():
#	if get_parent().name == "Fight":
#		if Global.Level >= 7:
#		if Global.LevelData[0]["cardShow"][Global.NowLevel-1] == null: 
#			$Control/card/Unlock.visible = false
#		if Global.LevelData[0]["buyShow"][Global.NowLevel-1] == null: 
#			$Control/card/CanBuy.visible = false
	$Control/emerald.visible = false
	pass

func text(mode):
	get_tree().paused = true
	Mode = mode
	#$Control/Title.text = Mode
	match Mode:
		"stop": $Control/Title.text = "暂停"
		"win": 
			$Control/Title.text = "胜利"
			if get_parent().name == "Fight"&&Global.NowLevel == Global.Level:
				if Global.Level<=6: $Control/card.visible = true
				if Global.Level<7: addPoint()
			if get_parent().name == "MiniGame": addPoint()
		"lose": 
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
	if get_parent().name == "MiniGame": $Control/card.free()
	pass
