extends TextureButton

signal fight
func _process(_delta):
	if Global.ChosenCard[-1] == null: visible = false
	else: visible = true
	pass

func _on_pressed():
	Global.ChoiceWindow.visible = false
	emit_signal("fight")
	pass
