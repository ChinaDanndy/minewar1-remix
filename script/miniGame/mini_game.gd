extends Node2D
var Game1
var Game2
var keepTime = 10
var score = 0
signal GameStart
signal Game1All
var ghost = preload("res://sence/miniGame/ghost.tscn")
var zombie = preload("res://sence/miniGame/zombie.tscn")
var MiniGame2ZombieTime = 2
var MiniGame2GhostTime = 1

func _ready():
	match Global.MiniGame:
		1: 
			Global.MiniGame1RandMin = 3
			Global.MiniGame1RandMax = 1
			Global.MiniGame1HoldTime = 1
			Global.MiniGame1RandGunpowder = 4
			$game2.free()
		2: 
			$game1.free()

	GameStart.connect(start)
	#await get_tree().create_timer(0.5,false).timeout
	emit_signal("GameStart")
	pass

func start():
	$overTimer.start(1)
	if $game2:
		game2GhostCreate()
		game2GhostCreate()
		game2GhostCreate()
		game2ZombieCreate()
	pass
	
func game2ZombieCreate():
	await get_tree().create_timer(randi_range(5,10),false).timeout
	var mob = zombie.instantiate()
	add_child(mob)
	mob.Name = "zombie"
	game2ZombieCreate()
	pass
	
func game2GhostCreate():

	await get_tree().create_timer(randi_range(0.5,3),false).timeout
	var mob = ghost.instantiate()
	add_child(mob)
	mob.Name = "ghost"
	game2GhostCreate()
	pass

func _process(_delta):
	$VBoxContainer/HBoxContainer1/ScoreVallue.text = str(Global.MiniGameScore)
	$VBoxContainer/HBoxContainer2/TimeValue.text = str(keepTime)
	if keepTime <= 0: 
		Global.StopWindow.text("over")
	pass


func _on_tree_entered():
	Global.MiniGameSence = self
	Global.MiniGameScore = 0
	Global.MiniGame2Pos1Y = $game2/mobPoint1.position.y
	Global.MiniGame2Pos2Y = $game2/mobPoint2.position.y
	Global.MiniGame2Pos3Y = $game2/mobPoint3.position.y
	keepTime = 30
	
	Game1 = $game1
	Game2 = $game2
	Game1.visible = true
	Game2.visible = true
	pass


func _on_over_timer_timeout():
	keepTime -= 1
	pass
