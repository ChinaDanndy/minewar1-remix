extends "res://script/fight/object/soldier.gd"
var stopPos
var stopTime
var stop = false

func firstSetting(soldier):
	position = Global.MonsterPoint
	if soldier == "creeper": add_to_group("creeper")#获得苦力怕id
	camp = Global.MONSTER

	super.firstSetting(soldier)
	if soldierName[0] == "end":
		currentAni = "stop"
		currentState = State.STOP
		standardAni = "stop"
		standardState = State.STOP
		changeState(currentAni,currentState)
		$endTimer.start(endTime)
	if stopTime == 0: Global.SummonEnemy.stopOver.connect(onStopOver)
	#if soldier == "skeleton": $Collision2.position.y = -(position.y-Global.FightSkyY)
	pass
	
func endTp():
	var targetArray = get_tree().get_nodes_in_group("villageObject")
	if !targetArray.is_empty():
		var target = targetArray[randi_range(0,targetArray.size()-1)]
		position.x = target.position.x+(collBox.x)
	pass
	
func _on_end_timer_timeout():
	endTp()
	pass
	
func changeState(AniName,StaName):
	if soldierName[0] == "end": $endTimer.stop()
	super.changeState(AniName,StaName)
	pass
	
func attack():
	super.attack()
	if soldierName[0] == "end": 
		endTp()
		$endTimer.start(endTime)
	pass


func _physics_process(_delta):
	#if effTimerId[1] != null: print(effTimerId[1].time_left)
	if Input.is_action_just_pressed("ui_test"): 
		if soldierName[0] == "zombie": health -= 3
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




