extends TextureButton
var sound = true
var soundOn1 = load("res://assets/UI/button/sound_normal1.png")
var soundOn2 = load("res://assets/UI/button/sound_normal1.png")
var soundOff1 = load("res://assets/UI/button/sound_close1.png")
var soundOff2 = load("res://assets/UI/button/sound_close2.png")
func _process(_delta): $click.volume_db = Global.SeDB

func _on_pressed():
	$click.play()
	match name:
		"soundButton": 
			sound = !sound
			soundChange()
		"teachButton":
			get_tree().paused = true
			Global.TeachWindow.visible = true
	pass

func _on_tree_entered():
	match name:
		"teachButton":
			Global.TeachWindow = get_parent().get_node("TeachWindow")
			Global.TeachWindow.visible = false
		"soundButton": 
			if Global.SeDB == 1: sound = true
			else: sound = false
			soundChange()
	pass
	
func soundChange():#音效按钮固定
	if sound == true: 
		self.texture_normal = soundOn1
		self.texture_pressed = soundOn2
		self.texture_hover  = soundOn2
		Global.SeDB = 1
	if sound == false: 
		self.texture_normal = soundOff1
		self.texture_pressed = soundOff2
		self.texture_hover  = soundOff2
		Global.SeDB = -80
	pass
