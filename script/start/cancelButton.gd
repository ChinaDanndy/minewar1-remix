extends TextureButton
signal reSetAll

func _on_pressed():
	match name:
		"levelCancelButton": Global.LevelChoiceWindow.visible = false
		"buyCancelButton": Global.BuyCardWindow.visible = false
		"bookCancelButton": Global.BookWindow.visible = false
		"miniGameCancelButton": Global.MiniGameWindow.visible = false
		"changePageButton": 
			Global.PageNow = !Global.PageNow
			emit_signal("reSetAll")
		
	pass
