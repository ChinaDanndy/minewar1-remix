extends Control


func _on_tree_entered():
	#Global.LevelChoiceButton = get_parent().get_node("LevelChoiceButton")
	#Global.BuyCardButton = get_parent().get_node("BuyCardButton")
	Global.LevelChoiceWindow = $LevelChoiceWindow
	Global.BuyCardWindow = $BuyCardWindow
	Global.CardTextWindow = $cardTextWindow
	Global.MiniGameWindow = $MiniGameWindow
	

	
	Global.LevelChoiceWindow.visible = false
	Global.BuyCardWindow.visible = false
	Global.CardTextWindow.visible = false
	Global.MiniGameWindow.visible = false
	
	
	Global.ChangePageButton = $BookWindow/main/changePageButton
	Global.ShowPicture = $BookWindow/main/HBoxContainer/textBackground/Picture
	Global.ShowName = $BookWindow/main/HBoxContainer/textBackground/Name
	Global.BookWindow = $BookWindow
	Global.BookWindow.visible = false
	pass
