extends Control

var soldier
var price


func _ready():
	Global.FightSence.cardMessage.connect(cardMessageOut)
	pass
func cardMessageOut():
	soldier = Global.LevelData[Global.Level][-1][int(str(name))-1]
	if soldier == null: 
		self.visible = false
	else:
		price = Global.STSData[soldier]["price"]
		$CardPrice.text = str(price)
		$CardName.text = soldier
	pass


func _on_pressed():
	Global.NowMoney -= price
	if Global.STSData[soldier]["type"] == Global.Type.PEOPLE:
		var friend = Global.Soldier.instantiate()
		Global.root.add_child(friend)
		friend.firstSetting(soldier)
		friend.position = Vector2(100,297)
	if Global.STSData[soldier]["type"] == Global.Type.TOWER||Global.STSData[soldier]["type"] == Global.Type.SKILL:
		var Area = Global.ChoiceArea.instantiate()
		Global.root.add_child(Area)
		Area.position = Vector2(100,297)
		Area.soldier = soldier
	pass # Replace with function body.
