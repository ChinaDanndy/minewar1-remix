extends TextureButton

func _process(_delta):
	if name == "buyCancelButton":
		get_parent().get_node("emeraldSquare/emeraldNumber").text = str(Global.Point)
	pass

func _on_pressed():
	match name:
		"levelCancelButton": Global.LevelChoiceWindow.visible = false
		"buyCancelButton": Global.BuyCardWindow.visible = false
		"miniGameCancelButton": Global.MiniGameWindow.visible = false
	pass
