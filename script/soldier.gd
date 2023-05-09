extends "res://script/object.gd"

func firstSetting(soldier):
	aniName = ["walk","attack","stop","death"]
	super.SetValue(soldier)
	if soldierName[1] != null&&shield>0: aniName = ["walk","attack","stop"]
	type = Global.Type.SOLDIER
	typeName = "soldier"
	SetAnimationAndCollBox(soldier)
	super.firstSetting(soldier)
	collision_layer = Global.LAyer[camp+1][0]
	if kind == Global.Kind.SEA:
		collision_layer = Global.LAyer[camp+1][1]
		collision_mask = Global.MAsk[camp+1][1]
	pass
	
func SetAnimationAndCollBox(soldier):
	if soldier=="thunderCreeper": aniName = ["walk","attack","death"]
	super.SetAnimationAndCollBox(soldier)
	pass

func _physics_process(_delta):
	if health <= 0&&currentState != State.DEATH: #死亡判定
		#死亡特效
		changeState("death",State.DEATH)
		$AnimatedSprite2D.material = null
	super._physics_process(_delta)
	pass
