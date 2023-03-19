extends TextureButton
var gameBoard = preload("res://sence/game_board.tscn")




func _on_pressed():
	var GameBoard = gameBoard.instantiate()
	Global.root.add_child(GameBoard)
	GameBoard.position = Vector2(200,200)
	GameBoard.stop()
	get_tree().paused = true
	pass # Replace with function body.
