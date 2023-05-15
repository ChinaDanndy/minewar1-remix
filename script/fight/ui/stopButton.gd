extends TextureButton

func _on_pressed():
	Global.StopWindow.text("stop")
	visible=false
	pass 

func _on_mouse_entered():
	Global.StopON = true
	pass 
func _on_mouse_exited():
	Global.StopON = false
	pass 


func _on_tree_entered():
	Global.StopButton = self
	Global.StopWindow = get_parent().get_parent().get_node("StopWindow")
	Global.StopWindow.visible = false
	pass
