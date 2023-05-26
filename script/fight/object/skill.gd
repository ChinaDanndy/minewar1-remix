extends "res://script/fight/object.gd"
var unPeopleFly = true
var thunderAphla = 0

func firstSetting(soldier):
	Global.FightSence.reloadSence.connect(reload)
	super.SetValue(soldier)
	$Sprite2D.texture = load("res://assets/objects/skill/%s.png"% soldier)
	#collBox = $Sprite2D.texture.get_size()
	name = soldier
	soldierName[0] = soldier
	currentState = State.FALL
	position.y = -20
	if camp == Global.MONSTER: currentState = State.STOP
	
	match soldier:
		"thunder","thunderBoss","thunderBossKill": 
			position.y = Global.FightGroundY-(collBox.y/2)
			$Sprite2D.modulate.a = 0
			collision_mask = 2
			var newBox = RectangleShape2D.new()
			newBox.size.x = aoeRange
			newBox.size.y = 20
			$CollisionShape2D.shape = newBox
			$CollisionShape2D.position.x = position.x
			$CollisionShape2D.position.y = 0
			$thunder.play()
	pass
	
func _process(_delta):
	$thunder.volume_db = Global.SeDB
	if currentState == State.FALL: position.y += dropSpeed
	if position.y >= Global.FightGroundY&&dropSpeed != null: 
		currentState = State.STOP
		position.y = Global.FightGroundY
		await get_tree().create_timer(0.1,false).timeout
		Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,null,null,[soldierName[0]],giveEffect,effValue,effTime,effTimes)
		
		queue_free()
			
	match soldierName[0]:
		"thunder","thunderBoss","thunderBossKill":  
			if thunderAphla == 0: $Sprite2D.modulate.a += Global.ThunderSpeed
			if $Sprite2D.modulate.a >= 1&&thunderAphla == 0:
				$CollisionShape2D.position.y = collBox.y/2-10
				thunderAphla += 1
				Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,false,null,
				null,["thunder"],giveEffect,effValue,effTime,effTimes)
				
				await get_tree().create_timer(0.05,false).timeout 
				$CollisionShape2D.position.y = 0 
				
			if thunderAphla > 0:
				$Sprite2D.modulate.a -= Global.ThunderSpeed
				if $Sprite2D.modulate.a <= 0: 
					collision_mask = 0
					await get_tree().create_timer(1,false).timeout 
					queue_free()
	pass

func _on_area_entered(area):
	if area.soldierName[0] == "creeper": 
		area.call_deferred("reSet",area.soldierName[1])
		area.remove_from_group("creeper")
	pass
	
func reload(): queue_free()

