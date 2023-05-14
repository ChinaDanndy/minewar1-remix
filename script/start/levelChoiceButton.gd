extends TextureButton

func _ready():
	Global.ChoiceWindow = Control.new()
	Global.ChoiceWindow.visible = true#给买卡许可,不能删
	
	Global.LevelChoiceWindow.visible = false
	Global.BuyCardWindow.visible = false
	await  get_tree().create_timer(0.2,false).timeout
	material = null
	pass

func _on_mouse_entered():
	material = Global.ButtonOutLine
	pass

func _on_mouse_exited():
	material = null
	pass

func _on_pressed():
	match name:
		"LevelChoiceButton": Global.LevelChoiceWindow.visible = true
		"BuyCardButton": Global.BuyCardWindow.visible = true
	#disabled = true
	material = null
	pass 


func _on_start_tree_entered():
	#Global.LevelChoiceButton = get_parent().get_node("LevelChoiceButton")
	Global.LevelChoiceWindow = get_parent().get_node("LevelChoiceWindow/LevelChoiceWindowLayer")
	#Global.BuyCardButton = get_parent().get_node("BuyCardButton")
	Global.BuyCardWindow = get_parent().get_node("BuyCardWindow/CanvasLayer")
	pass 
