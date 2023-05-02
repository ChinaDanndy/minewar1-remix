extends CharacterBody2D

var type = Global.Type.BASE

@export var health = 10
@export var camp = 0
@export var picture:Texture2D
func _ready():
	$Sprite2D.texture = picture
	
	var newBox = RectangleShape2D.new()#碰撞箱自适应
	newBox.size = picture.get_size()
	$CollisionShape2D.shape = newBox
	pass


func _process(_delta):
	$Label.text = str(health)
	if health<=0: 
		Global.StopWindowLayer.visible = true
		if camp == Global.VILLAGE: Global.StopWindow.text("lose")
		if camp == Global.MONSTER: Global.StopWindow.text("win")
		get_tree().paused = true
	pass
