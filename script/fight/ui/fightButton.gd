extends TextureButton

signal fight
func _process(_delta):
	if Global.ChosenCard[Global.CardUp-1] == null: visible = false
	else: visible = true
	pass

func _on_pressed():
	emit_signal("fight")
	Global.ChoiceWindow.visible = false
	
	pass
