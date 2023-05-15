extends Area2D
var AOE = preload("res://sence/miniGame/mini_game_aoe.tscn")

func _process(_delta):
	position += Global.MiniGame2FireworkSpeed
	if position.y <= -16: free()
	pass

func _on_area_entered(_area):
	
	
	var newAoe = AOE.instantiate()
	Global.root.add_child(newAoe)
	newAoe.position = position
	self.queue_free()
	pass
