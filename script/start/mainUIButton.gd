extends TextureButton

func _ready():
	Global.ChoiceWindow = Control.new()
	Global.ChoiceWindow.visible = true#给买卡许可,不能删
	match name:
		"LevelChoiceButton": $text.text = "开始游戏"
		"BuyCardButton": $text.text = "打开商店"
		"BookButton": $text.text = "打开图鉴"
		"MiniGameButton": $text.text = "玩小游戏"
	await  get_tree().create_timer(0.2,false).timeout
	material = null
	pass

func _on_mouse_entered():
	#material = Global.ButtonOutLine
	pass

func _on_mouse_exited():
	#material = null
	pass

func _on_pressed():
	match name:
		"LevelChoiceButton": Global.LevelChoiceWindow.visible = true
		"BuyCardButton": Global.BuyCardWindow.visible = true
		"BookButton": Global.BookWindow.visible = true
		"MiniGameButton": Global.MiniGameWindow.visible = true
	material = null
	pass 
