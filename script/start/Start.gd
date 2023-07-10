extends Control

func _on_tree_entered():
	$buttonGroup.visible = true
	Global.ReStartButtonWindow = $reStartWindow
	Global.LevelChoiceWindow = $LevelChoiceWindow
	Global.BuyCardWindow = $BuyCardWindow
	Global.CardTextWindow = $cardTextWindow
	Global.MiniGameWindow = $MiniGameWindow
	
	Global.ReStartButtonWindow.visible = false
	Global.LevelChoiceWindow.visible = false
	Global.BuyCardWindow.visible = false
	Global.CardTextWindow.visible = false
	Global.MiniGameWindow.visible = false
	pass
