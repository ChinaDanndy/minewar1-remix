extends TextureButton
var level

func _ready():
	level = int(str(name))
	var ParentName = get_parent().name
	if ParentName != "miniGame": 
		$text.text = str(level)
	material = null
	pass

func _on_mouse_entered():
	#material = Global.ButtonOutLine
	pass

func _on_mouse_exited():
	#material = null
	pass


func _on_pressed():
	if Global.LevelChoiceWindow.visible == true:
		match level:
			1,2,3,4: 
				Global.Level = level
				get_tree().change_scene_to_file("res://sence/fight/Fight.tscn")
	if Global.MiniGameWindow.visible == true:
		Global.MiniGame = level
		get_tree().change_scene_to_file("res://sence/miniGame/mini_game.tscn")

	pass 
