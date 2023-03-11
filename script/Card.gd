extends Area2D
var soldier = preload("res://sence/soldiers.tscn")
var soldiername
var price

func firstSetting(soldierName):
	soldiername = soldierName
	price = Global.SoldierData[soldierName]["price"]
	$CardName.text = soldiername
	$CardPrice.text = str(price)

	pass


func _on_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("ui_mouse_left")&&Global.NowMoney >= price:
		Global.NowMoney -= price
		var friend = soldier.instantiate()
		Global.root.add_child(friend)
		friend.firstSetting(soldiername)
		friend.position = Vector2(100,297)
	pass # Replace with function body.
