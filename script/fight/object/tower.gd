extends "res://script/fight/object.gd"
var unPeopleFly = true
var towKeepTime#

func firstSetting(soldier):
	super.SetValue(soldier)
	currentState = State.FALL
	currentAni = "stop"
	standardState = State.STOP
	standardAni = currentAni
	super.SetAnimationAndCollBox(soldier)
	super.firstSetting(soldier)
	add_to_group("villageObject")
	collision_layer = Global.LAyer[camp+1][2]
	position.y = Global.FightGroundY+collBox.y
	effDefence[Global.Effect.KNOCK] = true
	if soldier == "airDefence": 
		$Collision1.global_position.y = Global.FightSkyY+50
		$Collision1.position.x = $CollisionUp.position.x
		$Collision1.target_position.x = attRangeBasic[0]+abs($CollisionUp.position.x)
	pass

func _ready():
	$particles/gold.visible = false
	$se/outSe.volume_db = Global.SeDB
	$se/outSe.play()
	$particles/out.emitting = true
	pass

func _process(_delta):
	$se/gold.volume_db = Global.SeDB
#	if unPeopleFly == true:
#		position.y -= 2
	if position.y <= Global.FightGroundY-(collBox.y/2)&&dropSpeed != null:
		currentState = State.STOP
		dropSpeed = null
		$Collision1.collide_with_areas = true
		position.y = Global.FightGroundY-(collBox.y/2)
		if soldierName[0] == "projector": $Collision1.collide_with_areas = true
		if soldierName[0] == "golder"||soldierName[0] == "cave": 
			$SkillTimer.start(speed)
#			if soldierName[0] == "cave": _on_skill_timer_timeout()
		if towKeepTime != null: $DeathTimer.start(towKeepTime)
	#currentAni = "attack"
	if health <= 0:
		$SkillTimer.stop()
		$particles/gold.visible = false
		$goldplayer.stop()
#		$particles/cave.emitting = false
#			if !giveEffect[ani["usual"]].is_empty():
#				var usual = 1
#				Global.aoe_create(self,Global.CREATE,aoeModel[usual],aoeRange[usual],ifAoeHold[usual],
#				null,null,null,giveEffect[usual],effValue[usual],effTime[usual],effTimes[usual])
#				pass
	super._process(_delta)
pass

func _on_skill_timer_timeout():
	if soldierName[0] == "golder": 
		if Global.NowMoney+damage <= Global.Money: 
			Global.NowMoney += damage
		else: Global.NowMoney = Global.Money
		if Global.NowMoney != Global.Money:
			goldShow()
			$se/gold.play()
	#蜘蛛笼
#	if soldierName[0] == "cave":  
#		var enemy = Global.Soldier.instantiate()
#		enemy.camp = Global.MONSTER
#		enemy.firstSetting(projectile[0])
#		enemy.position.x = global_position.x
#		Global.root.add_child(enemy)
#		$particles/cave.emitting = true
#		$se/cave.play()
	$SkillTimer.start(speed)
	pass 
	
func goldShow():
	$particles/gold.visible = true
	$goldplayer.play("gold")
	await get_tree().create_timer(0.4,false).timeout
	$goldplayer.stop()
	$particles/gold.visible = false 
	pass

func _on_death_timer_timeout(): if health > 0: health = -10

