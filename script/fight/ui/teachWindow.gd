extends CanvasLayer
@onready var a = $text/MainTeach
func _ready():
	#$text.visible = false

	match get_parent().name:
		"Fight": $text/MainTeach.visible = true
		"MiniGame":
			$text/MiniGameTeach.visible = true
			if Global.MiniGame == 1: $text/MiniGameTeach1.visible = true
			if Global.MiniGame == 2: $text/MiniGameTeach2.visible = true
	
	pass

func _on_teach_close_pressed():
	get_tree().paused = false
	visible = false
	
	pass
