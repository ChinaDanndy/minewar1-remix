extends TextureButton
func _process(_delta): $click.volume_db = Global.SeDB

func _on_pressed():
	$click.play()
	Global.StopWindow.text("stop")
	pass 

func _on_mouse_entered():
	Global.StopON = true
	pass 
func _on_mouse_exited():
	Global.StopON = false
	pass 
	
func _on_tree_entered():
	Global.StopButton = self
	Global.StopWindow = get_parent().get_node("StopWindow")
	Global.StopWindow.visible = false
	pass
