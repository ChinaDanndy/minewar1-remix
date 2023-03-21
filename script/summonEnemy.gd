extends Node
var soldier = preload("res://sence/soldiers.tscn")
const soldierCD = [1.5,1,0.5]
enum  CDtype {WIDE,MIDDLE,TIGHT}

var stageTime
var soldierGroup = ["zombie","zombie"]
var cdType = CDtype.MIDDLE
var firstCD = 1
var soldierGroupCD = 5
var soldierGroupCDRand = 2
var stage = 0
var groupCount
var soldierCount
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
	groupCount = Global.LevelData[Global.Level][stage].size()-1#排除掉最后一组记录阶段持续时间的
	for i in groupCount:
		await get_tree().create_timer(Global.LevelData[Global.Level][stage][i]["firstCD"],false).timeout
		summonEnemy(i,stage)
		#groupCount是每个阶段最后一个组,该组别包含阶段持续时间
	if Global.LevelData[Global.Level][stage][groupCount]["stageCD"] != 0:
		await get_tree().create_timer(Global.LevelData[Global.Level][stage][groupCount]["stageCD"]+randi_range(
			-Global.LevelData[Global.Level][stage][groupCount]["stageCDTand"],Global.LevelData[Global.Level][stage][groupCount]["stageCDTand"]),false).timeout
		stage += 1 
		firstStart()
	pass

func summonEnemy(group,groupStage):

	soldierCount = Global.LevelData[Global.Level][stage][group]["group"].size()
	for j in soldierCount:
		var enemy = soldier.instantiate()
		Global.root.add_child(enemy)
		enemy.position = Vector2(400,297)
		enemy.firstSetting(Global.LevelData[Global.Level][stage][group]["group"][j])
		if soldierCount>1: await get_tree().create_timer(soldierCD[Global.LevelData[Global.Level][stage][group]["CDType"]],false).timeout
	
	await get_tree().create_timer(Global.LevelData[Global.Level][stage][group]["groupCD"]+randi_range(
		-Global.LevelData[Global.Level][stage][group]["groupCDRand"],Global.LevelData[Global.Level][stage][group]["groupCDRand"]),false).timeout
	if stage == groupStage: summonEnemy(group,groupStage)
	pass

