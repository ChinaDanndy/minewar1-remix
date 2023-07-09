extends "res://script/fight/object.gd"
var unPeopleFly = true
var thunderAphla = 0
var thunderSpeed = 0.02

func firstSetting(soldier):
	Global.FightSence.reloadSence.connect(reload)
	super.SetValue(soldier)
	$Sprite2D.texture = load("res://assets/objects/skill/%s.png"%soldier)
	name = soldier
	soldierName[0] = soldier
	currentState = State.FALL
	position.y = -20
	
	match soldier:
		"thunder","thunderBoss","thunderBossKill": 
			currentState = State.STOP
			position.y = Global.FightGroundY-(collBox.y/2)
			$Sprite2D.modulate.a = 0
			collision_mask = 2
			var newBox = RectangleShape2D.new()
			newBox.size.x = aoeRange
			newBox.size.y = 20
			$CollisionShape2D.shape = newBox
	pass
	
func _process(_delta):
	if currentState == State.FALL: position.y += dropSpeed
	if position.y >= Global.FightGroundY&&dropSpeed != null: 
		currentState = State.STOP
		dropSpeed = null
		position.y = Global.FightGroundY
		await get_tree().create_timer(0.04,false).timeout
		Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,null,null,
		[soldierName[0]],giveEffect,effValue,effTime,effTimes)
		queue_free()
			
	match soldierName[0]:
		"thunder","thunderBoss","thunderBossKill":  
			if thunderAphla == 0: $Sprite2D.modulate.a += thunderSpeed
			if $Sprite2D.modulate.a >= 1&&thunderAphla == 0:
				thunderAphla += 1
				$CollisionShape2D.position.y = collBox.y/2-20
				await get_tree().create_timer(0.05,false).timeout 
				$CollisionShape2D.position.y = 0 
				Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,
				null,["thunder"],giveEffect,effValue,effTime,effTimes)
			if thunderAphla > 0:
				$Sprite2D.modulate.a -= thunderSpeed
				if $Sprite2D.modulate.a <= 0: 
					collision_mask = 0
					await get_tree().create_timer(1,false).timeout 
					queue_free()
	pass

func _on_area_entered(area):
	if area.soldierName[0] == "creeper": 
		area.call_deferred("reSet",area.soldierName[1])
		area.soldierName[0] = null
		#area.remove_from_group("creeper")
	pass
	
func reload(): queue_free()

