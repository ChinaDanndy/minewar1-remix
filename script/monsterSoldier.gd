extends "res://sence/soldier.gd"
var stopPos
var stopTime
var stop = false

func firstSetting(soldier):
	name = "monsterSoldier"
	camp = Global.MONSTER
	type = Global.Type.PEOPLE
	super.firstSetting(soldier)
	if stopTime == 0: Global.SummonEnemy.stopOver.connect(onStopOver)
	pass
	

func _physics_process(_delta):
	super._physics_process(_delta)
	if stopPos != null:#敌方的行动与暂停
		if position.x <= stopPos&&stop == false:
			stop = true
			changeState(Ani.STOP,State.STOP)
			if stopTime !=0:
				await get_tree().create_timer(stopTime,false).timeout
				changeState(Ani.WALK,State.PUSH)
	pass
	
func onStopOver():
	changeState(Ani.WALK,State.PUSH)
	pass

