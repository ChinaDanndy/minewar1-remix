extends TextureButton
func _process(_delta): 
	match name:
		"BuyCardButton": if Global.Level < 2: visible = false
		"MiniGameButton": if Global.Level < 2: visible = false
	$click.volume_db = Global.SeDB
pass

func _ready():
	Global.ChoiceWindow = Control.new()
	Global.ChoiceWindow.visible = true#给买卡许可,不能删
	match name:
		"LevelChoiceButton": $text.text = "开始游戏"
		"BuyCardButton": $text.text = "打开商店"
		"MiniGameButton": $text.text = "玩小游戏"
	await get_tree().create_timer(0.2,false).timeout
	material = null
	pass

func _on_pressed():
	$click.play()
	match name:
		"LevelChoiceButton": Global.LevelChoiceWindow.visible = true
		"BuyCardButton": Global.BuyCardWindow.visible = true
		"MiniGameButton": Global.MiniGameWindow.visible = true
	pass 
