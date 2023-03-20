extends Control
var Mode
func _ready():
	self.visible = false
	pass

func text(mode):
	Mode = mode
	$Title.text = Mode
	match Mode:
		"stop": $HBoxContainer/Button2/Button2Text.text = "continue"
		"win": $HBoxContainer/Button2/Button2Text.text = "next"
		"lose": $HBoxContainer/Button2.visible = false
	pass

func usual():
	get_tree().paused = false
	visible = false
	$HBoxContainer/Button1.button_pressed = false
	$HBoxContainer/Button2.button_pressed = false
	$HBoxContainer/Button3.button_pressed = false
	get_tree().get_root().find_child("Stop",true,false).visible = true
	pass

func _on_button_1_pressed():
	get_tree().reload_current_scene()
	usual()
	pass


func _on_button_2_pressed():
	usual()
	if Mode == "win": 
		Global.Level += 1
		get_tree().reload_current_scene()
	pass 


func _on_button_3_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://sence/start.tscn")
	pass 
