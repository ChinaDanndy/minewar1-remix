extends "res://script/fight/object.gd"
var unPeopleFly = true
var towKeepTime#


func firstSetting(soldier):
	super.SetValue(soldier)
	type = Global.Type.TOWER
	typeName = "tower"
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
		print("sefdcvc")
		$Timer.start(time)
	if towKeepTime != null:
		await get_tree().create_timer(towKeepTime,false).timeout
		queue_free()
	pass

func _physics_process(_delta):
	print($Timer.time_left)
	if unPeopleFly == true:
		position.y += Global.DropSpeed 
		if position.y >= 297: 
			position.y = 297
			unPeopleFly = false
			if type == Global.Type.SKILL:
				await get_tree().create_timer(0.2,false).timeout
				#Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],aoeTime[Global.AoeSet.ATTACK],aoeTimes[Global.AoeSet.ATTACK],null,null,null,attackEffect,effValue,effTime,effTimes)
				queue_free()
	super._physics_process(_delta)
	#if health <= 0: queue_free()#炮塔坏了直接销毁
pass


func _on_timer_timeout():
	if soldierName[0] == "golder": if Global.NowMoney+damageBasic[0] <= Global.Money: Global.NowMoney += damageBasic[0]
	#蜘蛛笼
	if soldierName[0] == "cave":  
			print("aaaa")
			var enemy = Global.MonsterSoldier.instantiate()
			Global.root.add_child(enemy)
			enemy.firstSetting(projectile[0])
			enemy.position = position
			pass
	pass # Replace with function body.
