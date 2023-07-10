extends CanvasLayer
@onready var a = $text/MainTeach
func _ready():
	$text/MainTeach.visible = false
	$text/MiniGameTeach.visible = false
	$text/MiniGameTeach1.visible = false
	$text/MiniGameTeach2.visible = false
	$text/Start.visible = false
	match get_parent().name:
		"Start": 
			if Global.Teach == 0: teach()
			$text/Start.visible = true
		"Fight":
			if Global.Level ==1&&Global.Teach == 1: teach()
			$text/MainTeach.visible = true
		"MiniGame":
			$text/MiniGameTeach.visible = true
			if Global.MiniGame == 1: 
				if Global.Teach == 2: teach()
				$text/MiniGameTeach1.visible = true
			if Global.MiniGame == 2: 
				if Global.Teach == 3: teach()
				$text/MiniGameTeach2.visible = true
	pass
	
func teach():#第一次弹出提示框
	get_tree().paused = true
	visible = true
	Global.Teach += 1
	pass
	
func _process(_delta): $click.volume_db = Global.SeDB
func _on_teach_close_pressed():
	$click.play()
	get_tree().paused = false
	visible = false
	pass
