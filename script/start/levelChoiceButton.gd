extends TextureButton

func _ready():
	Global.LevelChoiceWindow.visible = false
	await  get_tree().create_timer(0.2,false).timeout
	material = null
	pass

func _on_mouse_entered():
	material = Global.ButtonOutLine
	pass

func _on_mouse_exited():
	material = null
	pass

func _on_pressed():
	Global.LevelChoiceWindow.visible = true
	disabled = true
	#button_pressed = false	
	material = null
	pass 


func _on_start_tree_entered():
	Global.LevelChoiceButton = self
	Global.LevelChoiceWindow = get_parent().get_node("LevelChoiceWindow/LevelChoiceWindowLayer")
	pass 
