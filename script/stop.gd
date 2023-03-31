extends TextureButton

func _on_pressed():
	Global.StopWindowLayer.visible = true
	Global.StopWindow.text("stop")
	get_tree().paused = true
	visible=false
	button_pressed=false
	pass 
