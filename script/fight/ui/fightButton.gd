extends TextureButton
signal FightStart

func _process(_delta):
	if Global.ChosenCard[-1] == null: visible = false
	else: visible = true
	pass

func _on_pressed():
	emit_signal("FightStart")
	Global.ChoiceWindow.visible = false
	pass
