extends TextureButton





func _on_pressed():
	get_parent().get_node("GameBoard").visible = true
	get_parent().get_node("GameBoard").text("stop")
	get_tree().paused = true
	visible=false
	button_pressed=false
	pass 
