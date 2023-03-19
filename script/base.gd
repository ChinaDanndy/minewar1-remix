extends CharacterBody2D
var camp = 0
var type = Global.Type.BASE
var health = 100


func picture(Camp):
	camp = Camp
	if camp == Global.VILLAGE: $Sprite2D.texture = load("res://assets/tower/villageBase.png")
	if camp == Global.MONSTER: $Sprite2D.texture = load("res://assets/tower/monsterBase.png")
	pass 



func _process(delta):
	$Label.text = str(health)
	pass
