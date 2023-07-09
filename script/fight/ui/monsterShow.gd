extends TextureRect
var soldier
var num
 
func _ready(): 
	size = Vector2(0,0)
	num = int(str(name))-1
	Global.FightSence.monsterShowLoad.connect(loadData)
	texture = null
	pass

func loadData():
	soldier = Global.AllMonster[num]
	if soldier != null:
		if num < 6:#icon
			texture = load("res://assets/objects/soldier/%s/stop/stop1.png"%soldier)
		else: texture = load("res://assets/objects/skill/%s.png"%soldier)
		global_position.y = Global.FightGroundY-Global.STSData[soldier]["collBox"].y
		if num != 0:#间距
			position.x = 0
			position.x = 70*num
	else: visible = false
	pass

func _on_mouse_entered():
	Global.CardTextWindow.updateText(soldier)
	Global.CardTextWindow.visible = true
	pass

func _on_mouse_exited():
	Global.CardTextWindow.visible = false
	pass
