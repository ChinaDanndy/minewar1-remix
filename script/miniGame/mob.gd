extends Area2D
var randPos = randi_range(0,2) #2 
var rightLeft = randi_range(0,1)
const  pos = [Vector2(1,0.05),Vector2(1,0),Vector2(1,-0.05),Vector2(1,0)]
var dic
var Name
var speed
var die = Vector2(1,1)
var speRand = Global.LevelData[0]["miniGame2"]["mobSpeed"]["rand"]
#const rightLeft 

func _ready():
	speed = Global.LevelData[0]["miniGame2"]["mobSpeed"][Name]+randf_range(-speRand,speRand)
	match rightLeft:
		0: #right
			position.x = -40
			dic = Vector2(1,1)
			$AnimatedSprite2D.flip_h = true
		1:#left
			position.x = 835+40
			dic = Vector2(-1,1)
	if Name == "zombie": randPos = 3
	position.y = Global.MiniGame2PosY[randPos]
	pass
	
func _process(_delta):
	position += speed*dic*pos[randPos]*die
	match rightLeft:
		0: if position.x >= 835+40: free()
		1: if position.x <= -40: free()
	pass
	
func death():
	die = Vector2(0,0)
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(0.3,false).timeout
	
	queue_free()
	pass



