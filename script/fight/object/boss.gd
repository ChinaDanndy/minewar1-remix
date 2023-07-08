extends "res://script/fight/object.gd"
@onready var norAni = $Normal
@onready var tpAni = $Tp
@onready var collLine = $RayCast2D
@onready var healthColor = $healthLine/Sprite2D

var originSize

var message = true
var bossSecHealth
var protectHealth
var protectCD
var shoot = preload("res://sence/fight/object/base.tscn")
var bossLv
var attackTime = 1
var bossSkillCut
var bossUp = 0
var bossShineSet = 0

func _ready():
	super.SetValue("creeperKing")
	super.addSoundAndParticles()
	Global.FightButton.fight.connect(bossStart)
	type = "base"
	soldierName[0] = "creeperKing"
	healthUp = health
	originSize = healthColor.texture.get_size().x
	camp = Global.MONSTER
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	collBox = Vector2(20,46)
	position.y = Global.FightGroundY-(collBox.y/2)
	norAni.visible = true
	tpAni.visible = false
	$RayCast2D.position.x = -collBox.x/2-20
	Global.FightSence.BossLv2.connect(Lv2)
	Global.BossProtect.ProtectDown.connect(protectDown)
	pass

func _process(_delta):
	if Input.is_action_just_pressed("ui_test"):
		#health = 0
		pass
	Global.MonsterPoint.x = global_position.x
	
	if health >0:
		healthColor.region_rect = Rect2(0,0,originSize*(health/healthUp),10)
		healthColor.position.x = -((originSize-(originSize*(health/healthUp)))/2)
	else: healthColor.region_rect =  Rect2(0,0,0,0)
	
	if $RayCast2D.is_colliding():
		if $attackTimer.time_left == 0: $attackTimer.start(speedBasic)
	else: $attackTimer.stop()
		
	if bossLv == 2:
		if bossUp >= bossSkillCut:#法阵充能 
			bossUp = 0
			if Global.BossSkill.frame!=12: Global.BossSkill.frame += 1
		#法阵闪烁
		if bossShineSet == 0: Global.BossSkill.modulate.a -= 0.01
		if Global.BossSkill.modulate.a <=0.4: bossShineSet = 1
		if bossShineSet == 1: Global.BossSkill.modulate.a += 0.01
		if Global.BossSkill.modulate.a >= 1: bossShineSet = 0
		if attackTime <= 0&&Global.VillageBase.health>0: 
			var newtThunder = Global.Skill.instantiate()
			newtThunder.position.x = Global.VillageBase.global_position.x
			newtThunder.camp = Global.MONSTER
			Global.root.add_child(newtThunder)
			newtThunder.firstSetting("thunder")
			Global.VillageBase.health = 0
	pass

func _on_death_timer_timeout(): 
	attackTime -= 1#法阵充能倒计时
	bossUp += 1
	pass

func _on_attack_timer_timeout(): 
	var newthunder = Global.Skill.instantiate()
	Global.root.add_child(newthunder)
	newthunder.camp = Global.MONSTER
	newthunder.firstSetting("thunder")
	newthunder.position.x = global_position.x-collBox.x/2-20

func Lv2():
	$healthLine.visible = false
	$RayCast2D.collide_with_areas = false
	$attackTimer.stop()
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	norAni.visible = false
	tpAni.visible = true
	tpAni.play("default")
	pass
	
func _on_tp_frame_changed():
	if tpAni.frame == 7&&tpAni.visible == true: 
		#explode()
		position.x = Global.BossPosX
pass

func _on_tp_animation_finished():
	norAni.visible = true
	tpAni.visible = false
	norAni.play("stop1")
	$healthLine.visible = true
	$RayCast2D.collide_with_areas = true
	explode()
	protectReset()
	attackTime = Global.LevelData[Global.NowLevel]["set"]["attackTime"]
	bossSkillCut = (attackTime/(Global.BossSkill.hframes-1))
	$deathTimer.start(1)
	Global.FightSence.SummonEnemy()
	bossLv = 2
	pass

func protectDown():
	$RayCast2D.collide_with_areas = false
	$attackTimer.stop()
	$deathTimer.stop()
	norAni.play("stop3")
	explode()
	await get_tree().create_timer(0.2,false).timeout
	attDefence = [false,false,false]
	effDefence = [true,true,true,true,false,false,true]
	await get_tree().create_timer(protectCD,false).timeout
	#explode()
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	norAni.play("stop1")
	protectReset()
	$RayCast2D.collide_with_areas = true
	$deathTimer.start(1)
	pass
	
func protectReset():
	Global.BossProtect.health = protectHealth
	Global.BossProtect.collision_layer = Global.LAyer[camp+1][2]
	Global.BossSkill.visible = true
	Global.BossSkill.position.x = Global.BossProtect.global_position.x
	Global.BossProtect.picture.visible  = true
	pass

func explode():
	var i = 0
	Global.aoe_create(self,Global.CREATE,aoeModel[i],aoeRange[i],ifAoeHold[i],attackType[i],damage[i],
	["crpeerKingExplode"],giveEffect[i],effValue[i],effTime[i],effTimes[i])
	souEff["attack"].playing = true
	particles["attack"].emitting = true
	pass

func bossStart():
	message = false
	pass

func _on_mouse_entered():
	if message == true: 
		Global.CardTextWindow.updateText(soldierName[0])
		Global.CardTextWindow.visible = true
	pass
	
func _on_mouse_exited():
	Global.CardTextWindow.visible = false
	pass
