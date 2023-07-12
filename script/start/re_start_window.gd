extends CanvasLayer

func _process(_delta):  $click.volume_db = Global.SeDB

func _on_correct_pressed():
	allHave()
	Global.Point = 0
	Global.Brought = {"baseUpdate":false,"cardUpdate":false,"moneyUpate":false,
	"power":false,"golder":false,"iron":false}
	Global.Level = 1
	pass

func _on_no_pressed(): 
	allHave()
	pass
	
func allHave():
	$click.play()
	get_tree().paused = false
	visible = false
	pass
