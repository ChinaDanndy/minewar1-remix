extends Area2D
var randPos = randi_range(0,2)
var rightLeft = randi_range(0,1)
const  pos = [Vector2(1,0.125),Vector2(1,0),Vector2(1,-0.125)]
var dic
var Name
#const rightLeft 


func _ready():
	match rightLeft:
		0: #right
			position.x = -40
			dic = Vector2(1,1)
			$AnimatedSprite2D.flip_h = true
		1:
			position.x = 835+40
			dic = Vector2(-1,1)
	match randPos:
		0: position.y = Global.MiniGame2Pos1Y
		1: position.y = Global.MiniGame2Pos2Y
		2: position.y = Global.MiniGame2Pos3Y
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_test"):
		print(position)
	match Name: 
		"ghost":
			position += Global.MiniGame2GhostSpeed*dic*pos[randPos]
		"zombie":
			position += Global.MiniGame2ZombieSpeed*dic*pos[randPos]
			pass
	match rightLeft:
		0: if position.x >= 835+40: free()

		1: if position.x <= -40: free()
	pass



