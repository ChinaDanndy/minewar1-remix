extends "res://script/fight/object/soldier.gd"

func firstSetting(soldier):
	camp = Global.VILLAGE
	super.firstSetting(soldier)
	pass

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_test"):
		queue_free()
		pass
	super._physics_process(_delta)
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
	if event.is_action_pressed("ui_mouse_left"):
		Global.Contrl = soldierName[0]
		$AnimatedSprite2D.material = Global.OutLine
	pass 
	





