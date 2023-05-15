extends Area2D

func _on_area_entered(area):
	Global.MiniGameScore += 1
	area.free()
	queue_free()
	pass
