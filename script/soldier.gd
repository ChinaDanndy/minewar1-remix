extends "res://script/object.gd"

func firstSetting(soldier):
	aniName = ["walk","attack","stop","death"]
	super.firstSetting(soldier)
	pass

func _physics_process(_delta):
	if health <= 0&&currentState != State.DEATH: #死亡判定
		#死亡特效
		changeState("death",State.DEATH)
		$AnimatedSprite2D.material = null
	super._physics_process(_delta)
	
	pass
