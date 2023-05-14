extends TextureButton
signal cardMessage

func _on_pressed():
	match name:
		"levelCancelButton": Global.LevelChoiceWindow.visible = false
		"buyCancelButton": Global.BuyCardWindow.visible = false
		"bookCancelButton": Global.BookWindow.visible = false
		"changePageButton": 
			Global.PageNow = !Global.PageNow
			
			emit_signal("cardMessage")
	pass
