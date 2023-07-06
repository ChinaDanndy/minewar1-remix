extends Control


func _on_tree_entered():
	Global.LevelChoiceWindow = $LevelChoiceWindow
	Global.BuyCardWindow = $BuyCardWindow
	Global.CardTextWindow = $cardTextWindow
	Global.MiniGameWindow = $MiniGameWindow
	
	Global.LevelChoiceWindow.visible = false
	Global.BuyCardWindow.visible = false
	Global.CardTextWindow.visible = false
	Global.MiniGameWindow.visible = false
	
	if Global.Level < 2:
		$buttonGroup/MiniGameButton.visible = false
	if Global.Level < 3:
		$buttonGroup/BuyCardButton.visible = false
	pass
