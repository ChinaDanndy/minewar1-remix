extends "res://script/fight/object/soldier.gd"
var stopPos
var stopTime
var stop = false

func firstSetting(soldier):
	position = Global.MonsterPoint
	if soldier == "creeper": add_to_group("creeper")#获得苦力怕id
	camp = Global.MONSTER
	super.firstSetting(soldier)
	if stopTime == 0: Global.SummonEnemy.stopOver.connect(onStopOver)
	if soldier == "skeleton": 
		$Collision2.position.y = -(position.y-Global.FightSkyY)
	pass
	

func _physics_process(_delta):
	#if effTimerId[1] != null: print(effTimerId[1].time_left)
	if Input.is_action_just_pressed("ui_test"): 
		$AnimatedSprite2D.pause()
		pass
	super._physics_process(_delta)
	if stopPos != null:#敌方的行动与暂停
		if position.x <= stopPos&&stop == false:
			stop = true
			changeState("stop",State.STOP)
			if stopTime !=0:
				await get_tree().create_timer(stopTime,false).timeout
				changeState("walk",State.PUSH)
	pass
	
func onStopOver():
	changeState("walk",State.PUSH)
	pass

