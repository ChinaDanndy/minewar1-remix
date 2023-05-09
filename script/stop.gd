extends TextureButton

func _on_pressed():
	Global.StopWindowLayer.visible = true
	Global.StopWindow.text("stop")
	get_tree().paused = true
	visible=false
	button_pressed=false
	pass 


func _on_mouse_entered():
	Global.StopON = true
	pass 


func _on_mouse_exited():
	Global.StopON = false
	pass # Replace with function body.
