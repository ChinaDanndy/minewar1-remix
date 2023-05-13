extends "res://script/fight/object.gd"

func firstSetting(soldier):
	super.SetValue(soldier)
	
	SetAnimationAndCollBox(soldier)
	super.firstSetting(soldier)
	
	
	
	collision_layer = Global.LAyer[camp+1][0]
	if kind == "sea": collision_layer = Global.LAyer[camp+1][1]
	if kind == "sky": position.y = Global.FightSkyY
	var distanceLandSky = Global.FightGroundY - Global.FightSkyY

	if coll2Pos == "landSky":#骷髅
		$Collision2.position.y = -(distanceLandSky)
		$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/2))
	if coll2Pos == "skyLand":#恶魂
		$Collision2.position.y = (distanceLandSky)
		$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/2))
	if coll2Pos == "skyLine":#活塞虫
		$Collision2.position.y = (distanceLandSky)
		$Collision2.position.x = -(attRangeBasic[1]/2)
	if coll2Pos != null: $Collision2.collide_with_areas = true
	if usualTime != null: $UsualTimer.start(usualTime)

	pass

func _on_usual_timer_timeout():#平常给予效果
	var usual = 2
	Global.aoe_create(self,Global.CREATE,aoeModel[usual],aoeRange[usual],ifAoeHold[usual]
	,null,null,null,giveEffect[usual],effValue[usual],effTime[usual],effTimes[usual])
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_test"):
		if camp == Global.VILLAGE: health = 0
		#shield = 0
		pass
	#移动控制
	position += speed*camp*speedDirection
	#血量低于临界攻击免疫变少
	if shield <= 0&&attDefShield != null:#盾坏免疫丢失
		attDefence = attDefOrigin
		attDefShield = null
		reSet(soldierName[1])
		
	if health <= healthEffValue: #低血量狂暴永久效果
		nowEffect[Global.Effect.ATTDAMAGE+Global.EffGood] = Global.EffValue[Global.Effect.ATTDAMAGE]
		nowEffect[Global.Effect.SPEED+Global.EffGood] = Global.EffValue[Global.Effect.SPEED]
		healthEffValue = -1

	super._process(_delta)
	pass



