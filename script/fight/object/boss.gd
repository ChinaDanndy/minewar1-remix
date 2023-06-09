extends "res://script/fight/object.gd"
@onready var norAni = $Normal
@onready var tpAni = $Tp
@onready var collLine = $RayCast2D
@onready var healthColor = $healthLine/health/ColorRect

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
	originSize = healthColor.size.x
	
	camp = Global.MONSTER
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	position.y = Global.FightGroundY-(collBox.y/2)
	norAni.visible = true
	tpAni.visible = false
	
	Global.FightSence.BossLv2.connect(Lv2)
	Global.FightSence.BossLv3.connect(Lv3)
	Global.BossProtect.ProtectDown.connect(protectDown)
	pass

func _process(_delta):
	#$cover.texture = $Normal.sprite_frames.get_frame_texture(
	#$Normal.animation,$Normal.frame)
	healthColor.size.x = originSize*(health/healthUp)
	Global.MonsterPoint.x = global_position.x
	$RayCast2D.force_raycast_update()

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

func _on_attack_timer_timeout(): craeteThu("thunder")
	
func Lv2():
	bossLv = 2
	norAni.play("walk")
	collLine.collide_with_areas = true
	attDefence = [false,false,true]
	effDefence = [true,true,true,true,false,false,true]
	pass
	
func Lv3():
	bossLv = 3
	$attackTimer.stop()
	explode()
	collLine.collide_with_areas = false
	norAni.visible = false
	tpAni.visible = true
	tpAni.play("default")
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	pass
	
func _on_tp_frame_changed():
	if tpAni.frame == 7&&tpAni.visible == true: position.x = Global.BossPosX

func _on_tp_animation_finished():
	norAni.visible = true
	tpAni.visible = false
	collLine.collide_with_areas = true
	norAni.play("stop1")
	protectReset()
	pass

func protectDown():
	attDefence = [false,false,false]
	effDefence = [true,true,true,true,false,false,true]
	norAni.play("stop3")
	explode()
	await get_tree().create_timer(protectCD,false).timeout
	norAni.play("stop1")
	Global.BossProtect.health = protectHealth
	protectReset()
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	pass
	
func protectReset():
	Global.BossProtect.picture.visible  = true
	Global.BossProtect.collision_layer = Global.LAyer[camp+1][2]
	pass

func craeteThu(thu):
	var newthunder = Global.Skill.instantiate()
	Global.root.add_child(newthunder)
	newthunder.camp = Global.MONSTER
	newthunder.firstSetting(thu)
	newthunder.position.x = global_position.x-45
	pass
	
func explode():
	var i = 0
	Global.aoe_create(self,Global.CREATE,aoeModel[i],aoeRange[i],ifAoeHold[i],attackType[i],damage[i],
	["crpeerKingExplode"],giveEffect[i],effValue[i],effTime[i],effTimes[i])
	souEff["attack"].playing = true
	particles["attack"].emitting = true
	pass






