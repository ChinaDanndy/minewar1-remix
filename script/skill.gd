extends "res://script/object.gd"
var unPeopleFly = true
var thunderAphla = 0

func firstSetting(soldier):
	$CollisionShape2D.queue_free()
	$Collision1.queue_free()
	$Collision2.queue_free()
	$AnimatedSprite2D.queue_free()
	$Label.queue_free()
	super.SetValue(soldier)
	$Sprite2D.texture = load("res://assets/objects/skill/%s.png"% soldier)
	type = Global.Type.SKILL
	super.firstSetting(soldier)
	collision_mask = 0
	if camp == Global.MONSTER: unPeopleFly = false
	if soldier == "thunder": 
		$Sprite2D.modulate.a = 0
		$thunderArea.collision_mask = 2
		var newBox = RectangleShape2D.new()
		newBox.size.x = aoeRange
		newBox.size.y = 20
		$thunderArea/thunderBox.shape = newBox
		$thunderArea.position.x = position.x
		$thunderArea.position.y = 0
		pass
	pass
	
func _physics_process(_delta):
	if unPeopleFly == true:
		position.y += Global.DropSpeed 
		if position.y >= 297: 
			position.y = 297
			unPeopleFly = false
			await get_tree().create_timer(0.2,false).timeout
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,null,null,["skill"],attackEffect,effValue,effTime,effTimes)
			queue_free()
	if soldierName[0] == "thunder": 
		if thunderAphla == 0: $Sprite2D.modulate.a += Global.ThunderSpeed
		if $Sprite2D.modulate.a >= 1&&thunderAphla == 0:
			$thunderArea.position.y = collBox.y/2-10
			await get_tree().create_timer(0.05,false).timeout  
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,null,["thunder"],attackEffect,effValue,effTime,effTimes)
			thunderAphla += 1
		if thunderAphla > 0:
			$thunderArea.position.y = 0
			$Sprite2D.modulate.a -= Global.ThunderSpeed
			if $Sprite2D.modulate.a <= 0: queue_free()
	pass


func _on_thunder_area_body_entered(body):
	if body.soldierName[0] == "creeper": body.reSet(body.soldierName[1])
	pass 
