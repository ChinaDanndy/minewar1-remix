extends "res://script/fight/object.gd"
var unPeopleFly = true
var thunderAphla = 0

func firstSetting(soldier):

	super.SetValue(soldier)
	$Sprite2D.texture = load("res://assets/objects/skill/%s.png"% soldier)
	#collBox = $Sprite2D.texture.get_size()
	super.firstSetting(soldier)
	if camp == Global.MONSTER: unPeopleFly = false
	
	match soldier:
		"thunder","thunderBoss","thunderBossKill": 
			$Sprite2D.modulate.a = 0
			collision_mask = 2
			var newBox = RectangleShape2D.new()
			newBox.size.x = aoeRange
			newBox.size.y = 20
			$CollisionShape2D.shape = newBox
			$CollisionShape2D.position.x = position.x
			$CollisionShape2D.position.y = 0
	pass
	
func _process(_delta):
	if unPeopleFly == true:
		position.y += Global.DropSpeed 
		if position.y >= Global.FightGroundY: 
			position.y = Global.FightGroundY
			unPeopleFly = false
			await get_tree().create_timer(0.1,false).timeout
			Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,null,null,["skill"],giveEffect,effValue,effTime,effTimes)
			queue_free()
			
	match soldierName[0]:
		"thunder","thunderBoss","thunderBossKill":  
			if thunderAphla == 0: $Sprite2D.modulate.a += Global.ThunderSpeed
			if $Sprite2D.modulate.a >= 1&&thunderAphla == 0:
				thunderAphla += 1
				Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,null,["thunder"],giveEffect,effValue,effTime,effTimes)
				$CollisionShape2D.position.y = collBox.y/2-10
				await get_tree().create_timer(0.05,false).timeout 
				$CollisionShape2D.position.y = 0 
			if thunderAphla > 0:
				$Sprite2D.modulate.a -= Global.ThunderSpeed
				if $Sprite2D.modulate.a <= 0: queue_free()
	pass

func _on_area_entered(area):
	if area.soldierName[0] == "creeper": area.reSet(area.soldierName[1])
	pass
