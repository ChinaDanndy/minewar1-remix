extends Node2D
var keepTime = 0
var firstTime = 0
var lastTime = 0
var game
signal GameStart
signal Game1All
signal Game1First
signal Game1Last
var ghost = preload("res://sence/miniGame/ghost.tscn")
var ghMin = Global.LevelData[0]["miniGame2"]["timeRand"]["ghost"]["Min"]
var ghMax = Global.LevelData[0]["miniGame2"]["timeRand"]["ghost"]["Max"]
var zombie = preload("res://sence/miniGame/zombie.tscn")
var zomMin = Global.LevelData[0]["miniGame2"]["timeRand"]["zombie"]["Min"]
var zomMax = Global.LevelData[0]["miniGame2"]["timeRand"]["zombie"]["Max"]

func _ready():
	match Global.MiniGame:
		1: 
			$game2.free()
			$game1.visible = true
			game = "miniGame1"
		2:  
			$game1.free()
			$game2.visible = true
			game = "miniGame2"
	keepTime = Global.LevelData[0][game]["keepTime"]
	firstTime = Global.LevelData[0][game]["firstTime"]
	lastTime = keepTime-firstTime-Global.LevelData[0][game]["lastTime"]
	GameStart.connect(start)
	#await get_tree().create_timer(0.5,false).timeout#开始延迟
	emit_signal("GameStart")
	pass

func start():
	$overTimer.start(1)
	if game == "miniGame1":
		await get_tree().create_timer(firstTime,false).timeout
		emit_signal("Game1First")
		await get_tree().create_timer(lastTime,false).timeout
		emit_signal("Game1Last")
		pass
	if game == "miniGame2":
		game2GhostCreate()
		await get_tree().create_timer(firstTime,false).timeout
		game2GhostCreate()
		game2ZombieCreate()
		await get_tree().create_timer(lastTime,false).timeout
		#game2GhostCreate()
		#game2GhostCreate()
		pass
	pass

	
func game2ZombieCreate():
	await get_tree().create_timer(randi_range(zomMin,zomMax),false).timeout
	var mob = zombie.instantiate()
	mob.Name = "zombie"
	add_child(mob)
	game2ZombieCreate()
	pass
	
func game2GhostCreate():
	await get_tree().create_timer(randi_range(ghMin,ghMax),false).timeout
	var mob = ghost.instantiate()
	mob.Name = "ghost"
	add_child(mob)
	game2GhostCreate()
	pass

func _process(_delta):
	$CanvasLayer/VBoxContainer/HBoxContainer1/ScoreVallue.text = str(Global.MiniGameScore)
	$CanvasLayer/VBoxContainer/HBoxContainer2/TimeValue.text = str(keepTime)
	if keepTime <= 0: Global.StopWindow.text("over")
	pass

func _on_tree_entered():
	Global.MiniGameSence = self
	Global.MiniGameScore = 0
	for i in 4:
		Global.MiniGame2PosY.append(get_node("game2/mobPoint%s"%(i+1)).position.y)
#	Global.MiniGame2Pos1Y = $game2/mobPoint1.position.y
#	Global.MiniGame2Pos2Y = $game2/mobPoint2.position.y
#	Global.MiniGame2Pos3Y = $game2/mobPoint3.position.y
	keepTime = 30
	pass

func _on_over_timer_timeout():
	keepTime -= 1
	pass



