extends TextureButton

func _on_pressed():
	Global.StopWindow.text("stop")
	visible=false
	button_pressed=false
	pass 

func _on_mouse_entered():
	Global.StopON = true
	pass 
func _on_mouse_exited():
	Global.StopON = false
	pass 
