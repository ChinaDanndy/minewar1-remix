extends Area2D
var speed = Global.LevelData[0]["miniGame2"]["fireworkSpeed"]
var stop = 1
func _ready(): $tail.emitting = true

func _process(_delta):
	$normal.volume_db = Global.SeDB
	$well.volume_db = Global.SeDB
	position += speed*Vector2.UP*stop
	if position.y <= -16: 
		monitoring = false
		await get_tree().create_timer(1,false).timeout
		queue_free()
	pass

func _on_area_entered(_area):
	collision_mask = 0
	$Sprite2D.visible = false
	stop = 0
	$AOE.monitoring = true
	await get_tree().create_timer(0.02,false).timeout
	$AOE.monitoring = false
	await get_tree().create_timer(3,false).timeout
	queue_free()
	pass

func _on_aoe_area_entered(area):
	match area.Name:
		"zombie":
			$explodeWell.emitting = true
			$well.play()
			Global.MiniGameScore += 4
		"ghost":
			$explodeNormal.emitting = true
			$normal.play()
			Global.MiniGameScore += 1
	area.queue_free()
	pass
