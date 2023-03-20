extends TextureButton

func _ready():
	if name == "LevelSign": 
		get_parent().get_node("LevelChoice/CanvasLayer").visible = false
	material = null
	pass

func _on_mouse_entered():
	material = Global.OutLine
	pass


func _on_mouse_exited():
	material = null
	pass


func _on_pressed():
	if name == "LevelSign": 
		get_parent().get_node("LevelChoice/CanvasLayer").visible = true
		disabled = true
	if name == "CancelButton": 
		get_tree().get_root().find_child("CanvasLayer",true,false).visible = false
		get_tree().get_root().find_child("LevelSign",true,false).disabled = false
		material = null
		button_pressed = false
	pass 
