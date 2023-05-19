extends "res://script/fight/object.gd"

func firstSetting(soldier):
	super.SetValue(soldier)
	super.SetAnimationAndCollBox(soldier)
	super.firstSetting(soldier)
	collision_layer = Global.LAyer[camp+1][0]
	position.y = Global.FightGroundY-(collBox.y/2)
	if unSee == true: 
		collision_layer = Global.LAyer[camp+1][1]
		$AnimatedSprite2D.modulate.a = 0.5

	if kind == "sky": 
		position.y = Global.FightSkyY
	var distanceLandSky = Global.FightGroundY - Global.FightSkyY

	match coll2Pos:
		"landSky":#骷髅
			$Collision2.position.y = -(distanceLandSky)
			$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/2))
		"skyLand":#恶魂
			$Collision2.position.y = (distanceLandSky)
			$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/2))
		"skyLine":#活塞虫
			$Collision2.position.y = (distanceLandSky)
			$Collision2.position.x = -(attRangeBasic[1]/2)
	if coll2Pos != null: $Collision2.collide_with_areas = true
	if usualTime != null: $UsualTimer.start(usualTime)
	pass


func _on_usual_timer_timeout():#平常给予效果
	var usual = 3
	Global.aoe_create(self,Global.CREATE,aoeModel[usual],aoeRange[usual],ifAoeHold[usual]
	,null,null,null,giveEffect[usual],effValue[usual],effTime[usual],effTimes[usual])
	pass

func _process(_delta):
	#if Input.is_action_just_pressed("ui_test"):
		#$AnimatedSprite2D.play("attack")
		#if camp == Global.VILLAGE: health = 0
		#shield = 0
	#移动控制
	position.x += speed*camp*speedDirection*speedState

	#血量低于临界攻击免疫变少
	if shield <= 0&&attDefShield != null:#盾坏免疫丢失
		attDefence = attDefOrigin
		attDefShield = null
		reSet(soldierName[1])
		
	if health <= healthEffValue: #低血量狂暴永久效果
		
#		if soldierName[0] == "ballon":
#			$Collision1.collide_with_areas = false
#			reSet(soldierName[1])
#			changeState("stop",State.FALL)
#		else:
		nowEffect[Global.Effect.ATTDAMAGE+Global.EffGood] = Global.EffValue[Global.Effect.ATTDAMAGE]
		nowEffect[Global.Effect.SPEED+Global.EffGood] = Global.EffValue[Global.Effect.SPEED]
		
		healthEffValue = -1000
	
	
	if position.y >= Global.FightGroundY&&dropSpeed != null: 
		dropSpeed = null
		if startDrop == true:
			position.y = Global.FightGroundY-(collBox.y/2)
			changeState("walk",State.PUSH)
			$Collision1.collide_with_areas = true
			startDrop = false
		if currentAni == "deathFall":
			#var i = 1
			#aoeRange[i] = aoeRange[i]*1.5#扩大爆炸范围
			#Global.aoe_create(self,Global.CREATE,aoeModel[i],aoeRange[i],ifAoeHold[i],attackType[i],damage[i],
			#damagerType[i],giveEffect[i],effValue[i],effTime[i],effTimes[i])
			changeState("death",State.DEATH)
		
	super._process(_delta)
	pass






