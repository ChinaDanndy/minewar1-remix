extends Control
var Mode
func _ready():
	#Global.StopWindowLayer.visible = false
	pass

func text(mode):
	get_tree().paused = true
	Mode = mode
	$Control/Title.text = Mode
	match Mode:
		"stop": $Control/HBoxContainer/Button2/Button2Text.text = "continue"
		"win": $Control/HBoxContainer/Button2/Button2Text.text = "next"
		"lose": $Control/HBoxContainer/Button2.visible = false
	Global.StopWindowLayer.visible = true
	pass

func usual():
	get_tree().paused = false
	Global.StopWindowLayer.visible = false
	$Control/HBoxContainer/Button1.button_pressed = false
	$Control/HBoxContainer/Button2.button_pressed = false
	$Control/HBoxContainer/Button3.button_pressed = false
	Global.StopButton.visible = true
	pass

func _on_button_1_pressed():
	usual()
	Global.root.get_tree().reload_current_scene()
	#get_tree().reload_current_scene()
	pass
func _on_button_2_pressed():
	usual()
	if Mode == "win": 
		Global.Level += 1
		get_tree().reload_current_scene()
	pass 
func _on_button_3_pressed():
	usual()
	get_tree().change_scene_to_file("res://sence/start/Start.tscn")
	pass 
