extends "res://script/fight/object.gd"

func firstSetting(soldier):
	super.SetValue(soldier)
	typeName = "soldier"
	SetAnimationAndCollBox(soldier)
	super.firstSetting(soldier)
	collision_layer = Global.LAyer[camp+1][kind]
	if kind == Kind.SKY: position.y = Global.FightSkyY
	var distanceLandSky = Global.FightGroundY - Global.FightSkyY

	if coll2Pos == "land":#骷髅
		$Collision2.position.y = -(distanceLandSky)
		$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/2))
	if coll2Pos == "skyBais":#恶魂
		$Collision2.position.y = (distanceLandSky)
		$Collision2.position.x = camp*(distanceLandSky-(attRangeBasic[1]/2))
	if coll2Pos == "skyLine":#活塞虫
		$Collision2.position.y = (distanceLandSky)
		$Collision2.position.x = -(attRangeBasic[1]/2)
	if coll2Pos != null: 

		$Collision2.collide_with_areas = true

	
	
	pass

func _physics_process(_delta):
	#移动控制
	position += speed*camp*speedDirection*speedState
	#血量低于临界攻击免疫变少
	if shield <= 0&&attDefShield != null&&attDefence!=attDefOrigin:#盾坏免疫丢失
		attDefence = attDefOrigin
		reSet(soldierName[1])
	if health <= 0&&currentState != State.DEATH: #死亡判定
		#死亡特效
		changeState("death",State.DEATH)
		$AnimatedSprite2D.material = null
	super._physics_process(_delta)
	pass
