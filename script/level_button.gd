extends TextureButton


@export var level:int

func _ready():
	$text.text = str(level)
	pass

func _on_mouse_entered():
	material = Global.OutLine
	pass


func _on_mouse_exited():
	material = null
	pass


func _on_pressed():
	Global.Level = level-1
	get_tree().change_scene_to_file("res://sence/Fight.tscn")
	pass 
