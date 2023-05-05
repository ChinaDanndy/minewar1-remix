extends "res://script/object.gd"
var unPeopleFly = true

func firstSetting(soldier):
	name = "villageTower"
	camp = Global.VILLAGE
	type = Global.Type.TOWER
	speedBasic = 0
	currentState = State.STOP
	currentAni = "stop"
	standardState = currentState
	standardAni = currentAni
	aniName = ["attack","stop"]
	super.firstSetting(soldier)
	await get_tree().create_timer(towKeepTime,false).timeout
	queue_free()
	pass

func _physics_process(_delta):
	if unPeopleFly == true:
		position.y += Global.DropSpeed 
		if position.y >= 297: 
			position.y = 297
			unPeopleFly = false
			if type == Global.Type.SKILL:
				await get_tree().create_timer(0.2,false).timeout
				Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],aoeTime[Global.AoeSet.ATTACK],aoeTimes[Global.AoeSet.ATTACK],null,null,null,attackEffect,effValue,effTime,effTimes)
				queue_free()
	if health <= 0: queue_free()#炮塔坏了直接销毁
	super._physics_process(_delta)
pass
