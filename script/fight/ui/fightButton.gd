extends TextureButton
signal fight
func _process(_delta):
	$click.volume_db = Global.SeDB
	if Global.ChosenCard[Global.CardUp-1] == null: 
		visible = false
	else: 
		visible = true
	pass

func _on_pressed():
	$click.play()
	emit_signal("fight")
	Global.ChoiceWindow.visible = false
	Global.CardTextWindow.visible = false
	pass
