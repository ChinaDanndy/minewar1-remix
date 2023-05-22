extends "res://script/fight/object.gd"
var stopPos
var stopTime
var stop = false

func firstSetting(soldier):
	super.SetValue(soldier)
	super.SetAnimationAndCollBox(soldier)
	super.firstSetting(soldier)
	
	match camp:
		Global.VILLAGE: position.x = Global.VillagePoint.x
		Global.MONSTER: position.x = Global.MonsterPoint.x
	
	if stopTime == 0: Global.SummonEnemy.stopOver.connect(onStopOver)
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
	,null,null,[null],giveEffect[usual],effValue[usual],effTime[usual],effTimes[usual])
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_test"):
		if camp == Global.VILLAGE: health = 0
		#$AnimatedSprite2D.play("attack")

	position.x = clamp(position.x,Global.VillagePoint.x-16,Global.MonsterPoint.x+16)#限制移动范围
	if Global.Contrl == soldierName[0]&&currentState != State.DEATH&&currentState != State.FALL: 
		#if (collKind!=Global.CollKind.NARESPE)||(collKind==Global.CollKind.NARESPE&&ifFirstEffect==false): 
		contrl()
	position.x += speed*camp*speedDirection*speedState#移动控制

	if stopPos != null&&ifOnlyAttBase == false:#敌方的行动与暂停
		if position.x <= stopPos&&stop == false:
			stop = true
			changeState("stop",State.STOP)
			if stopTime > 0:
				$stopTimer.start(stopTime)

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
		if currentAni == "deathFall": changeState("death",State.DEATH)
	super._process(_delta)
	pass

func contrl():#玩家的单位控制
	if Input.is_action_just_pressed("ui_right")&&currentState != State.ATTACK: 
		changeState("walk",State.PUSH)
	#防止攻击时还能继续前进
	if Input.is_action_just_pressed("ui_down"): changeState("stop",State.STOP)
	if Input.is_action_just_pressed("ui_left"): changeState("walk",State.BACK)
	pass

func regenerationSet():  $particles/regeneration.emitting = true


func _on_input_event(_viewport,event, _shape_idx):
	if event.is_action_pressed("ui_mouse_left")&&camp == Global.VILLAGE: #soldierName[0]!="assassinFirst":
		Global.Contrl = soldierName[0]
		material = Global.SoldierOutLine
	pass 
func _on_stop_timer_timeout():
	changeState("walk",State.PUSH)
	pass 
	
func onStopOver():
	changeState("walk",State.PUSH)
	pass



