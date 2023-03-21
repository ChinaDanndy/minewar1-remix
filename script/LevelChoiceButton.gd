extends TextureButton

func _ready():
	if name == "LevelChoiceButton": Global.LevelChoiceWindow.visible = false
	material = null
	pass

func _on_mouse_entered():
	material = Global.OutLine
	pass


func _on_mouse_exited():
	material = null
	pass


func _on_pressed():
	if name == "LevelChoiceButton": 
		Global.LevelChoiceWindow.visible = true
		disabled = true
	if name == "CancelButton": 
		Global.LevelChoiceWindow.visible = false
		Global.LevelChoiceButton.disabled = false
	button_pressed = false	
	material = null
	pass 


func _on_start_tree_entered():
	if name == "LevelChoiceButton":
		Global.LevelChoiceButton = self
		Global.LevelChoiceWindow = get_parent().get_node("LevelChoiceWindow/LevelChoiceWindowLayer")
	pass 
