extends Control

var soldierName
var price


func _ready():

	Global.FightSence.cardMessage.connect(cardMessageOut)
	pass
func cardMessageOut():
	soldierName = Global.LevelData[Global.Level][-1][int(str(name))-1]
	#print(Global.LevelData[Global.Level][-1][int(str(name))-1])
	#print(Global.SoldierData["steve"]["price"])
	
	if soldierName!= null: 
		price = Global.SoldierData[soldierName]["price"]
		$CardPrice.text = str(price)
		$CardName.text = soldierName
	pass


func _on_pressed():
	#Global.NowMoney -= price
	var friend = Global.Soldier.instantiate()
	Global.root.add_child(friend)
	friend.firstSetting(soldierName)
	friend.position = Vector2(100,297)
	pass # Replace with function body.
