extends Node
var object = 1
var times:Array
var allTime:Array
var waitTime:Array
var groupCount = 0
var soldierCount:Array
signal stopOver

func _ready(): 
	name = "summonEnemy"
	times.clear()
	soldierCount.clear()
	allTime.clear()
	waitTime.clear()
	groupCount = Global.LevelData[Global.NowLevel]["groups"].size()#记录有多少组人
	for i in groupCount: 
		times.append(0)
		soldierCount.append(0)
		waitTime.append(0)
		var firstCD = Global.LevelData[Global.NowLevel]["groups"][i]["firstCD"]
		var soldierCountCalu = Global.LevelData[Global.NowLevel]["groups"][i]["soldier"].size()-1
		var soldierCD = Global.LevelData[Global.NowLevel]["groups"][i]["soldierCD"]
		var groupCD = Global.LevelData[Global.NowLevel]["groups"][i]["groupCD"]
		var groupCDRand = Global.LevelData[Global.NowLevel]["groups"][i]["groupCDRand"]
		var groupTimes = Global.LevelData[Global.NowLevel]["groups"][i]["groupTimes"]-1
		allTime.append(firstCD+((soldierCountCalu*soldierCD)+(groupCD+groupCDRand))
		*groupTimes+(soldierCountCalu*soldierCD))
		firstStart(i)
	#print(allTime)
	pass
	
func firstStart(i):
	waitTime[i] = Global.LevelData[Global.NowLevel]["groups"][i]["firstCD"]
	if !Global.LevelData[Global.NowLevel]["groups"][i]["firstCDNum"].is_empty():
		var newTime = 0
		newTime = allTime.slice(Global.LevelData[Global.NowLevel]["groups"][i]["firstCDNum"][0]-1,
		Global.LevelData[Global.NowLevel]["groups"][i]["firstCDNum"][1],true)
		var newWaitTime = 0
		for j in newTime: newWaitTime += j#计算总等待时间
		waitTime[i]+= newWaitTime
	await get_tree().create_timer(waitTime[i],false).timeout
	summonEnemy(i)
	pass

func summonEnemy(group):
	soldierCount[group] = Global.LevelData[Global.NowLevel]["groups"][group]["soldier"].size()
	for j in soldierCount[group]:
		var enemy = Global.Soldier.instantiate()
		enemy.camp = Global.MONSTER
		Global.root.add_child(enemy)
		if Global.LevelData[Global.NowLevel]["groups"][group]["stopPos"] != null:
			enemy.stopPos = Global.LevelData[Global.NowLevel]["groups"][group]["stopPos"]
			enemy.stopTime = Global.LevelData[Global.NowLevel]["groups"][group]["stopTime"]
		enemy.firstSetting(Global.LevelData[Global.NowLevel]["groups"][group]["soldier"][j])
		if soldierCount[group]>1: 
			await get_tree().create_timer(Global.LevelData[Global.NowLevel]["groups"]
			[group]["soldierCD"],false).timeout
	times[group] += 1
	if Global.LevelData[Global.NowLevel]["groups"][group]["groupTimes"] == 0: 
		againWait(group)#永久持续出兵
	else:
		if times[group] != Global.LevelData[Global.NowLevel]["groups"][group]["groupTimes"]: 
			againWait(group)
		else: if group == groupCount-1: Global.LevelOver = true
#			if Global.LevelData[Global.NowLevel]["groups"][group]["stopTime"] == -1: emit_signal("stopOver")	pass
	
func againWait(group):
	await get_tree().create_timer(Global.LevelData[Global.NowLevel]["groups"][group]["groupCD"]+randf_range(
		-Global.LevelData[Global.NowLevel]["groups"][group]["groupCDRand"],
		Global.LevelData[Global.NowLevel]["groups"][group]["groupCDRand"]),false).timeout
	summonEnemy(group)
	pass

