extends TextureButton
func _on_pressed():

	get_tree().paused = true
	Global.TeachWindow.visible = true
	pass

func _on_tree_entered():
	Global.TeachWindow = get_parent().get_node("TeachWindow")
	Global.TeachWindow.visible = false
	pass
