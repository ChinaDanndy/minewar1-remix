extends Node
var soldier = preload("res://sence/soldiers.tscn")

var soldierGroup = ["zombie"]
const soldierCD = [1.5,1,0.5]
enum  CDtype {WIDE,MIDDLE,TIGHT}
var cdType = CDtype.WIDE
var firstCD = 1
var soldierGroupCD = 5
var soldierGroupCDrand = 2
var soldierTest = 1

func _ready():
#	add_child(enemy)
#
#	enemy.Health = 10
#
#	if count == 0: 
#		enemy.position = Vector2(250,297)
#		enemy.ifUsuallyEffect = false 
#		enemy.usuallyEffGoodOrBad = [1,1,1,1,1,1,1]
#		enemy.usuallyEffect = [false,false,false,true,false,false,false,false,false]
#
#		enemy.ifDeathEffect = false
#		enemy.deathEffGoodOrBad = [1,1,1,1,1,-1,1]
#		enemy.deathEffect = [false,false,false,false,false,true,false,false,false]
#	if count == 1: 
#		enemy.position = Vector2(270,297)
#
#	if count == 2: enemy.position = Vector2(300,297)
#	if count == 3: enemy.position = Vector2(300,297)
#	enemy.firstSetting()
	pass
	
func firstStart():
	await get_tree().create_timer(firstCD).timeout
	summonEnemy()
	pass

func summonEnemy():
	var soldierGroupLength = soldierGroup.size()
	for i in soldierGroupLength:
		var enemy = soldier.instantiate()
		add_child(enemy)
		enemy.position = Vector2(400,297)
		enemy.firstSetting(soldierGroup[i])
		if soldierGroupLength>1: await get_tree().create_timer(soldierCD[cdType]).timeout
	await get_tree().create_timer(soldierGroupCD+randi_range(-soldierGroupCDrand,soldierGroupCDrand)).timeout
	summonEnemy()
	pass

