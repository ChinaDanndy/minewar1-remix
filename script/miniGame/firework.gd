extends Area2D
var AOE = preload("res://sence/miniGame/mini_game_aoe.tscn")
var speed = Global.LevelData[0]["miniGame2"]["fireworkSpeed"]

func _process(_delta):
	position += speed*Vector2.UP
	if position.y <= -16: free()
	pass

func _on_area_entered(_area):
	var newAoe = AOE.instantiate()
	newAoe.position = position
	Global.root.call_deferred("add_child",newAoe)
	self.queue_free()
	pass
