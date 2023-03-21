extends CharacterBody2D
var camp = 0
var type = Global.Type.BASE
var health = 10


func picture(Camp):
	camp = Camp
	if camp == Global.VILLAGE: $Sprite2D.texture = load("res://assets/tower/villageBase.png")
	if camp == Global.MONSTER: $Sprite2D.texture = load("res://assets/tower/monsterBase.png")
	pass 



func _process(delta):
	$Label.text = str(health)
	if health<=0: 
		Global.StopWindowLayer.visible = true
		if camp == Global.VILLAGE: Global.StopWindow.text("lose")
		if camp == Global.MONSTER: Global.StopWindow.text("win")
		get_tree().paused = true
	
	pass
