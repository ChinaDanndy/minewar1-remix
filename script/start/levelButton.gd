extends TextureButton
@export var level:int

func _ready():
	$text.text = str(level)
	material = null
	pass

func _on_mouse_entered():
	material = Global.OutLine
	pass


func _on_mouse_exited():
	material = null
	pass


func _on_pressed():
	match level:
		1,2,3,4: 
			Global.Level = level
			get_tree().change_scene_to_file("res://sence/fight/Fight.tscn")
	pass 
