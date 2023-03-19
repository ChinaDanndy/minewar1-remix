extends Control
var mode
func stop():
	mode = "stop"
	$Title.text = "stop"
	$Button1/Button1Text.text = "continue"
	pass


func _on_button_1_pressed():
	if mode == "stop":
		get_tree().paused = false
		
		queue_free()
	pass # Replace with function body.
