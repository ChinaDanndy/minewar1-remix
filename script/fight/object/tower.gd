extends "res://script/fight/object.gd"
var unPeopleFly = true
var towKeepTime#


func firstSetting(soldier):
	super.SetValue(soldier)
	currentState = State.STOP
	currentAni = "stop"
	standardState = currentState
	standardAni = currentAni
	super.SetAnimationAndCollBox(soldier)
	super.firstSetting(soldier)
	add_to_group("villageObject")
	collision_layer = Global.LAyer[camp+1][2]
	$Collision1.collide_with_areas = false
	if soldierName[0] == "projector": $Collision1.collide_with_areas = true
	if soldierName[0] == "golder"||soldierName[0] == "cave": 
		
		$Timer.start(speed.x)
	if towKeepTime != null:
		await get_tree().create_timer(towKeepTime,false).timeout
		queue_free()
	pass

func _process(_delta):
	if unPeopleFly == true:
		position.y += Global.DropSpeed
		if position.y >= 297: 
			unPeopleFly = false
			position.y = 297
			if !giveEffect[1].is_empty():
				var usual = 1
				Global.aoe_create(self,Global.CREATE,aoeModel[usual],aoeRange[usual],ifAoeHold[usual],
				null,null,null,giveEffect[usual],effValue[usual],effTime[usual],effTimes[usual])
				pass
	super._process(_delta)
pass

func _on_timer_timeout():
	if soldierName[0] == "golder": if Global.NowMoney+damageBasic[0] <= Global.Money: Global.NowMoney += damageBasic[0]
	#蜘蛛笼
	if soldierName[0] == "cave":  
			var enemy = Global.MonsterSoldier.instantiate()
			Global.root.add_child(enemy)
			enemy.firstSetting(projectile[0])
			enemy.position = position
			pass
	$Timer.start(speed.x)
	pass
