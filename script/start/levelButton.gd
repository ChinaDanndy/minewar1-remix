extends TextureButton
var level

func _ready():
	level = int(str(name))
	var ParentName = get_parent().name
	if ParentName == "miniGame": 
		$Lock.visible = false
		$text.text = ""
		if level == 2&&Global.Level-1 <= Global.LevelData[0]["buyShow"].find("miniGame2"): 
			visible = false
	else:
		if Global.Level >= level: $Lock.visible = false
		$text.text = str(level)

	pass

func _on_pressed():
	if Global.LevelChoiceWindow.visible == true:
		Global.NowLevel = level
		get_tree().change_scene_to_file("res://sence/fight/Fight.tscn")
		
	if Global.MiniGameWindow.visible == true:
		Global.MiniGame = level
		get_tree().change_scene_to_file("res://sence/miniGame/mini_game.tscn")
	pass 
