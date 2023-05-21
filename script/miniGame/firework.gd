extends Area2D
var AOE = preload("res://sence/miniGame/mini_game_aoe.tscn")
var speed = Global.LevelData[0]["miniGame2"]["fireworkSpeed"]
var stop = 1
func _ready(): $tail.emitting = true

func _process(_delta):
	$AudioStreamPlayer.volume_db = Global.SeDB
	position += speed*Vector2.UP*stop
	if position.y <= -16: 
		monitoring = false
		await get_tree().create_timer(1,false).timeout
		queue_free()
	pass

func _on_area_entered(_area):
	collision_mask = 0
	$Sprite2D.visible = false
	$tail.emitting = false
	$explode.emitting = true
	stop = 0
	var newAoe = AOE.instantiate()
	newAoe.position = position
	Global.root.call_deferred("add_child",newAoe)
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1,false).timeout
	queue_free()
	pass



