extends TextureButton

func _on_pressed():
	match name:
		"levelCancelButton": Global.LevelChoiceWindow.visible = false
		"buyCancelButton": Global.BuyCardWindow.visible = false
	pass
