extends "res://script/fight/object/soldier.gd"

func firstSetting(soldier):
	position.x = Global.VillagePoint.x
	if soldier == "skyer": position.y = Global.FightSkyY
	camp = Global.VILLAGE
	super.firstSetting(soldier)
	add_to_group("villageObject")
	pass

func _process(_delta):
	position.x = clamp(position.x,Global.VillagePoint.x-16,Global.MonsterPoint.x+16)#限制移动范围
	super._process(_delta)
	if Global.Contrl == soldierName[0]&&currentState != State.DEATH&&currentAni != "sea": 
		#if (collKind!=Global.CollKind.NARESPE)||(collKind==Global.CollKind.NARESPE&&ifFirstEffect==false): 
		contrl()
	pass

func contrl():#玩家的单位控制
	if Input.is_action_just_pressed("ui_right")&&currentState != State.ATTACK: 
		changeState("walk",State.PUSH)
	#防止攻击时还能继续前进
	if Input.is_action_just_pressed("ui_down"): changeState("stop",State.STOP)
	if Input.is_action_just_pressed("ui_left"): changeState("walk",State.BACK)
	pass

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("ui_mouse_left")&&soldierName[0]!="assassinFirst":
		Global.Contrl = soldierName[0]
		$AnimatedSprite2D.material = Global.SoldierOutLine
	pass 
	





