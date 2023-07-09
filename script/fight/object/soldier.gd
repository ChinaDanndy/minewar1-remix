extends "res://script/fight/object.gd"
var stopPos
var stopTime
var stop = false

@onready var Ani = $AnimatedSprite2D

func firstSetting(soldier):
	super.SetValue(soldier)
	super.firstSetting(soldier)
	super.SetAnimationAndCollBox(soldier)
	aniSpeedBasic = speedBasic+0.2
	$Collision1.collide_with_areas = true
	
	match camp:
		Global.VILLAGE: 
			#if soldier == Global.Contrl: $AnimatedSprite2D.material = Global.SoldierOutLine
			position.x = Global.VillagePoint.x
			#add_to_group(soldier)
			add_to_group("villageSoldier")
		Global.MONSTER: 
			position.x = Global.MonsterPoint.x
			add_to_group("monsterSoldier")
	collision_layer = Global.LAyer[camp+1][0]
	position.y = Global.FightGroundY-(collBox.y/2)
	if unSee == true: 
		collision_layer = Global.LAyer[camp+1][1]
		$AnimatedSprite2D.modulate.a = 0.5
	if kind == "sky": position.y = Global.FightSkyY
	else: $Collision1.position.y = (collBox.y/2)-10
		
	var distanceLandSky = Global.FightGroundY - Global.FightSkyY
	match coll2Pos:
		"landSky":#骷髅
			$Collision2.position.y = -(distanceLandSky)
			$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/3))
		"skyLand":#恶魂
			$Collision2.position.y = (distanceLandSky)-10
			$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/3))
		"skyLine":#活塞虫
			$Collision2.position.y = (distanceLandSky)-10
			$Collision2.position.x = -(attRangeBasic[1]/2)
	if coll2Pos != null: $Collision2.collide_with_areas = true
	if usualTime != null: $UsualTimer.start(usualTime)
	
	#	if stopTime == 0: Global.SummonEnemy.stopOver.connect(onStopOver)
#	if projectile.is_empty(): 
#	else: $Collision1.position.y = (collBox.y/2)-25
	pass
	
func _on_usual_timer_timeout():#平常给予效果
	var usual = 3
	var newdamagerType = [null]
	if giveEffect[usual][Global.Effect.DAMAGE] == Global.EFFGOOD:
		newdamagerType = ["regenerationDo"]
	Global.aoe_create(self,Global.CREATE,aoeModel[usual],aoeRange[usual],ifAoeHold[usual]
	,null,null,newdamagerType,giveEffect[usual],effValue[usual],effTime[usual],effTimes[usual])
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_test"):
		#print(Global.Contrl)
		#print(Global.MonsterBase.position)
		#if camp == Global.VILLAGE: health = 0
		#$AnimatedSprite2D.play("attack")
		pass
	if camp == Global.MONSTER:
		if Global.MonsterPoint.x - position.x>50&&soldierName[0] == "creeper"&&!is_in_group("creeper"):
			add_to_group("creeper")#获得苦力怕id给劈闪电用
	if camp == Global.VILLAGE: 
		position.x = clamp(position.x,Global.VillagePoint.x-16,Global.MonsterPoint.x+16)#限制移动范围
		if Global.Contrl == soldierName[0]&&currentState != State.DEATH&&speed>0:
		#&&currentState != State.FALL: 
		#if(collKind!=Global.CollKind.NARESPE)||(collKind==Global.CollKind.NARESPE&&ifFirstEffect==false): 
			if Ani.material == null: Ani.material = Global.SoldierOutLine
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
		
	if tpDistance != null:
		if camp == Global.MONSTER:
			var toVillageBase = abs(position.x-(Global.VillageBase.global_position.x
			+(Global.VillageBase.collBox.x/2)+20))
			if toVillageBase <= tpDistance: tpDistance = null
		pass
		
#	if health <= healthEffValue: #低血量狂暴永久效果
##		if soldierName[0] == "ballon":
##			$Collision1.collide_with_areas = false
##			reSet(soldierName[1])
##			changeState("stop",State.FALL)
#		if tpDistance == null:
#			nowEffect[Global.Effect.ATTDAMAGE+Global.EffGood] = Global.EffValue[Global.Effect.ATTDAMAGE]
#			nowEffect[Global.Effect.SPEED+Global.EffGood] = Global.EffValue[Global.Effect.SPEED]
#		else: 
#			if health > 0: position.x = Global.VillagePoint.x+50#末影人二次传送
#		healthEffValue = -1000
#	if position.y+(collBox.y/2) >= Global.FightGroundY&&dropSpeed != null: 
#		dropSpeed = null
#		#position.y = Global.FightGroundY-(collBox.y/2)
#		if startDrop == true:
#			changeState("walk",State.PUSH)
#			$Collision1.collide_with_areas = true
#			startDrop = false
#		if currentAni == "deathFall": changeState("death",State.DEATH)
	super._process(_delta)
	pass

func contrl():#玩家的单位控制
	if Input.is_action_just_pressed("ui_right")&&currentState != State.ATTACK: 
		changeState("walk",State.PUSH)
	#防止攻击时还能继续前进
	if Input.is_action_just_pressed("ui_down"): changeState("stop",State.STOP)
	if Input.is_action_just_pressed("ui_left"): changeState("walk",State.BACK)
	pass

func _on_input_event(_viewport,event, _shape_idx):
	if event.is_action_pressed("ui_mouse_left")&&camp == Global.VILLAGE&&unSee == false:
		var clean = get_tree().get_nodes_in_group("villageSoldier")
		for i in clean: i.Ani.material = null
		Global.Contrl = soldierName[0]
	pass 
func _on_stop_timer_timeout():
	changeState("walk",State.PUSH)
	pass 
#func onStopOver():
#	changeState("walk",State.PUSH)
#	pass



