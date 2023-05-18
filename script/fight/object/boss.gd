extends "res://script/fight/object.gd"
@onready var norAni = $Normal
@onready var tpAni = $Tp
@onready var collLine = $RayCast2D
var speState = 1
var stop = 1

var shoot = preload("res://sence/fight/object/base.tscn")

func _ready():
	super.SetValue("creeperKing")
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	#collBox = Vector2(24,50)
	position.y = Global.FightGroundY-(collBox.y/2)
	#health = 50
	
	norAni.visible = true
	tpAni.visible = false
	Global.FightSence.BossLv2.connect(Lv2)
	Global.FightSence.BossLv3.connect(Lv3)
	Global.BossProtect.ProtectDown.connect(protectDown)
	pass

func _process(_delta):
	Global.MonsterPoint.x = global_position.x
	$RayCast2D.force_raycast_update()
	
	$Label.text = str(health)
	if Global.NowLevel == 2:
		if position.x <= Global.BossStopX:
			if norAni.animation != "stop2": norAni.play("stop2")
			speState = 0
		
		position.x -= 0.3*speState
		
	if $RayCast2D.is_colliding():
		if norAni.animation != "stop2"&&Global.NowLevel == 2: 
			norAni.play("stop2")
			speState = 0
		if $attackTimer.time_left == 0: $attackTimer.start(1)
	else:
		if norAni.animation == "stop2": 
			if position.x > Global.BossStopX&&Global.NowLevel == 2:
				norAni.play("walk")
				speState = 1
		$attackTimer.stop()


	pass

func _on_attack_timer_timeout():
	craeteThu("thunderBoss")

	pass
	
func Lv2():
	norAni.play("walk")
	collLine.collide_with_areas = true
	attDefence = [false,false,true]
	effDefence = [true,true,true,true,false,false,true]
	pass
	
func Lv3():
	$attackTimer.stop()
	collLine.collide_with_areas = false
	norAni.visible = false
	tpAni.visible = true
	tpAni.play("default")
	var i = 0
	Global.aoe_create(self,Global.CREATE,"all",aoeRange[i],ifAoeHold[i],attackType[i],damage[i],
	damagerType[i],giveEffect[i],effValue[i],effTime[i],effTimes[i])
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	pass
	

func _on_tp_frame_changed():
	if tpAni.frame == 7&&tpAni.visible == true: 
		position.x = Global.BossPosX
	pass


func _on_tp_animation_finished():
	norAni.visible = true
	tpAni.visible = false
	collLine.collide_with_areas = true
	norAni.play("stop1")
	Global.BossProtect.picture.visible  = true
	Global.BossProtect.monitorable = true
	pass

func protectDown():
	attDefence = [false,false,true]
	effDefence = [true,true,true,true,false,false,true]
	norAni.play("stop3")
	craeteThu("thunderBossKill")
	await get_tree().create_timer(7,false).timeout
	norAni.play("stop1")
	Global.BossProtect.health = 5
	Global.BossProtect.picture.visible  = true
	Global.BossProtect.monitorable = true
	attDefence = [true,true,true]
	effDefence = [true,true,true,true,true,true,true]
	pass

	
	
func craeteThu(thu):
	var newthunder = Global.Skill.instantiate()
	Global.root.add_child(newthunder)
	newthunder.camp = Global.MONSTER
	newthunder.firstSetting(thu)
	newthunder.position.y = Global.FightGroundY-(Global.STSData["thunder"]["collBox"].y/2)
	newthunder.position.x = position.x-30
	pass
	

#func _on_normal_frame_changed():

#	pass






