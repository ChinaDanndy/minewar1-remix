extends Area2D
func _ready():
	await get_tree().create_timer(0.02,false).timeout
	queue_free()
	pass

func _on_area_entered(area):
	Global.MiniGameScore += 1
	area.death()
	queue_free()
	pass
