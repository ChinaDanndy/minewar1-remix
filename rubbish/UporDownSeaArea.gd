extends CharacterBody2D

var UporDown = ""
var Type = "BLOCK"
func _ready():
	$SeaLandChangePoint.add_to_group("AREA",true)
	pass
