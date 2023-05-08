extends "res://script/object.gd"
var unPeopleFly = true
func firstSetting(soldier):
	super.SetValue(soldier)
	var picture = Sprite2D.new()
	picture.texture = load("res://assets/objects/%s/stop/stop1.png"% soldier)
	add_child(picture)
	pass
	
func _physics_process(_delta):
	if unPeopleFly == true:
		position.y += Global.DropSpeed 
		if position.y >= 297: 
			position.y = 297
			unPeopleFly = false
			await get_tree().create_timer(0.2,false).timeout
			var newAoe = Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold)
			Global.damage_Calu(newAoe,Global.TRANSFER,null,null,null,attackEffect,effValue,effTime,effTimes,Global.SkillHold)
			newAoe.firstsetting()
			queue_free()
	pass
