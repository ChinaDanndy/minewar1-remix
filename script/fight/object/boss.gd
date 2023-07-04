extends "res://script/fight/object.gd"
@onready var norAni = $Normal
@onready var tpAni = $Tp
@onready var collLine = $RayCast2D
@onready var healthColor = $healthLine/Sprite2D

var originSize

var bossSecHealth
var protectHealth
var protectCD
var shoot = preload("res://sence/fight/object/base.tscn")
var bossLv

func _ready():
	super.SetValue("creeperKing")
	super.addSoundAndParticles()
	healthUp = health
	originSize = healthColor.texture.get_size().x
	$healthLine.visible = false
	
	camp = Global.MONSTER
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	collBox = Vector2(20,46)
	position.y = Global.FightGroundY-(collBox.y/2)
	norAni.visible = true
	tpAni.visible = false
	$RayCast2D.position.x = -collBox.x/2-20
	
	Global.FightSence.BossLv2.connect(Lv2)
	Global.FightSence.BossLv3.connect(Lv3)
	Global.BossProtect.ProtectDown.connect(protectDown)
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_test"):
		health -= 2
		pass
		
	#print(Global.MonsterBase.position)
	#$AnimatedSprite2D.play("attack")
	#$cover.texture = $Normal.sprite_frames.get_frame_texture(
	#$Normal.animation,$Normal.frame)
	if health >0:
		healthColor.region_rect = Rect2(0,0,originSize*(health/healthUp),10)
		healthColor.position.x = -((originSize-(originSize*(health/healthUp)))/2)
	else: healthColor.region_rect =  Rect2(0,0,0,0)
	#size.x = originSize*(health/healthUp)
	Global.MonsterPoint.x = global_position.x
	#$RayCast2D.force_raycast_update()

	if position.x <= Global.BossStopX&&bossLv == 2&&norAni.animation != "stop2":
			norAni.play("stop2")
	if $RayCast2D.is_colliding():
		
		if norAni.animation != "stop2"&&bossLv == 2: norAni.play("stop2")
		if $attackTimer.time_left == 0: $attackTimer.start(aniSpeedBasic)
	else:
		if bossLv == 2: 
			if norAni.animation != "walk"&&position.x > Global.BossStopX: norAni.play("walk")
			if position.x > Global.BossStopX: position.x -= speed
		$attackTimer.stop()
	pass

func _on_attack_timer_timeout(): 
	var newthunder = Global.Skill.instantiate()
	Global.root.add_child(newthunder)
	newthunder.camp = Global.MONSTER
	newthunder.firstSetting("thunder")
	newthunder.position.x = global_position.x-collBox.x/2-20
	
func Lv2():
	bossLv = 2
	norAni.play("walk")
	$healthLine.visible = true
	attDefence = [false,false,true]
	effDefence = [true,true,true,true,false,false,true]
	pass
	
func Lv3():
	bossLv = 3
	$healthLine.visible = false
	$attackTimer.stop()
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	collLine.collide_with_areas = false
	norAni.visible = false
	tpAni.visible = true
	tpAni.play("default")
	pass
	
func _on_tp_frame_changed():
	if tpAni.frame == 7&&tpAni.visible == true: 
		explode()
		position.x = Global.BossPosX
	
func _on_tp_animation_finished():
	norAni.visible = true
	tpAni.visible = false
	collLine.collide_with_areas = true
	norAni.play("stop1")
	protectReset()
	pass

func protectDown():
	$healthLine.visible = true
	attDefence = [false,false,false]
	effDefence = [true,true,true,true,false,false,true]
	norAni.play("stop3")
	explode()
	await get_tree().create_timer(protectCD,false).timeout
	$healthLine.visible = false
	norAni.play("stop1")
	protectReset()
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	pass
	
func protectReset():
	Global.BossProtect.health = protectHealth
	Global.BossProtect.collision_layer = Global.LAyer[camp+1][2]
	Global.BossSkill.visible = true
	Global.BossProtect.picture.visible  = true
	pass

func explode():
	var i = 0
	Global.aoe_create(self,Global.CREATE,aoeModel[i],aoeRange[i],ifAoeHold[i],attackType[i],damage[i],
	["crpeerKingExplode"],giveEffect[i],effValue[i],effTime[i],effTimes[i])
	souEff["attack"].playing = true
	particles["attack"].emitting = true
	pass






