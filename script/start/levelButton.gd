extends TextureButton
var level

func _ready():
	$Lock.visible = true
	level = int(str(name))
	pass
	
func _process(_delta): 
	$click.volume_db = Global.SeDB
	var ParentName = get_parent().name
	if ParentName == "miniGame": 
		$Lock.visible = false
		$text.text = ""
		if level == 2&&Global.Level-1 < 4:
			visible = false
	else:
		if Global.Level >= level: $Lock.visible = false
		else: $Lock.visible = true
		$text.text = str(level)
	pass

func _on_pressed():
	$click.play()
	if Global.LevelChoiceWindow.visible == true:
		Global.NowLevel = level
		get_tree().change_scene_to_file("res://sence/fight/Fight.tscn")
		
	if Global.MiniGameWindow.visible == true:
		Global.MiniGame = level
		get_tree().change_scene_to_file("res://sence/miniGame/mini_game.tscn")
	pass 
