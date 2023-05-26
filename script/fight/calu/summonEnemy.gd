extends Node
const soldierCD = [1.5,1,0.5]
enum  CDtype {WIDE,MIDDLE,TIGHT}

var object = 1
var times:Array
var allTime:Array
var groupCount = 0
var soldierCount = 0
signal stopOver



func _ready(): 
	name = "summonEnemy"
	times.clear()
	allTime.clear()
	groupCount = Global.LevelData[Global.NowLevel]["groups"].size()#记录有多少组人
	for i in groupCount: 
		times.append(0)
		allTime.append((((Global.LevelData[Global.NowLevel]["groups"][i]["soldierCD"]*
		(Global.LevelData[Global.NowLevel]["groups"][i]["soldier"].size()-1))+
		Global.LevelData[Global.NowLevel]["groups"][i]["groupCD"]+
		Global.LevelData[Global.NowLevel]["groups"][i]["groupCDRand"])*
		(Global.LevelData[Global.NowLevel]["groups"][i]["times"]-1))+
		(Global.LevelData[Global.NowLevel]["groups"][i]["soldierCD"]*
		(Global.LevelData[Global.NowLevel]["groups"][i]["soldier"].size()-1)))
		firstStart(i)
	pass
	
func firstStart(i):
	if !Global.LevelData[Global.NowLevel]["groups"][i]["firstCDNum"].is_empty():
		var newTime = allTime.slice(Global.LevelData[Global.NowLevel]["groups"][i]["firstCDNum"][0]-1,
		Global.LevelData[Global.NowLevel]["groups"][i]["firstCDNum"][1],true)
		var newWaitTime = 0
		for j in newTime: newWaitTime += j#计算总等待时间
		Global.LevelData[Global.NowLevel]["groups"][i]["firstCD"] = newWaitTime+Global.LevelData[Global.NowLevel]["groups"][i]["firstCD"]
	await get_tree().create_timer(Global.LevelData[Global.NowLevel]
	["groups"][i]["firstCD"],false).timeout
	summonEnemy(i)
		#groupCount是每个阶段最后一个组,该组别包含阶段持续时间
	#if Global.LevelData[Global.Level][stage][groupCount]["stageCD"] != 0:
		#await get_tree().create_timer(Global.LevelData[Global.Level][stage][groupCount]["stageCD"]+randi_range(
			#-Global.LevelData[Global.Level][stage][groupCount]["stageCDTand"],Global.LevelData[Global.Level][stage][groupCount]["stageCDTand"]),false).timeout
		#stage += 1 
		#firstStart()
	pass

func summonEnemy(group):
	soldierCount = Global.LevelData[Global.NowLevel]["groups"][group]["soldier"].size()
	for j in soldierCount:
		var enemy = Global.Soldier.instantiate()
		enemy.camp = Global.MONSTER
		Global.root.add_child(enemy)
		if Global.LevelData[Global.NowLevel]["groups"][group]["stopPos"] != null:
			enemy.stopPos = Global.LevelData[Global.NowLevel]["groups"][group]["stopPos"]
			enemy.stopTime = Global.LevelData[Global.NowLevel]["groups"][group]["stopTime"]
		enemy.firstSetting(Global.LevelData[Global.NowLevel]["groups"][group]["soldier"][j])
		if soldierCount>1: 
			await get_tree().create_timer(Global.LevelData[Global.NowLevel]["groups"][group]["soldierCD"],false).timeout
	times[group] += 1
	if Global.LevelData[Global.NowLevel]["groups"][group]["times"] == 0: againWait(group)#
	else:
		if times[group] != Global.LevelData[Global.NowLevel]["groups"][group]["times"]: againWait(group)
		else: 
			if Global.LevelData[Global.NowLevel]["groups"][group]["stopTime"] == -1: emit_signal("stopOver")
			if group == groupCount-1: Global.LevelOver = true
		#if stage == groupStage: summonEnemy(group,groupStage)#处于本阶段才释放本阶段士兵
	pass
	
func againWait(group):
	await get_tree().create_timer(Global.LevelData[Global.NowLevel]["groups"][group]["groupCD"]+randf_range(
		-Global.LevelData[Global.NowLevel]["groups"][group]["groupCDRand"],
		Global.LevelData[Global.NowLevel]["groups"][group]["groupCDRand"]),false).timeout
	summonEnemy(group)
	pass

