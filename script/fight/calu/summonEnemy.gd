extends Node
const soldierCD = [1.5,1,0.5]
enum  CDtype {WIDE,MIDDLE,TIGHT}

var object = 1
var times:Array
var groupCount = 0
var soldierCount = 0
signal stopOver


func _ready(): 
	name = "summonEnemy"
	groupCount = Global.LevelData[Global.NowLevel][object].size()#记录有多少组人
	for i in groupCount:
		await get_tree().create_timer(Global.LevelData[Global.NowLevel][object][i]["firstCD"],false).timeout
		times.append(0)
		summonEnemy(i)
	pass
	
func firstStart():

		#groupCount是每个阶段最后一个组,该组别包含阶段持续时间
	#if Global.LevelData[Global.Level][stage][groupCount]["stageCD"] != 0:
		#await get_tree().create_timer(Global.LevelData[Global.Level][stage][groupCount]["stageCD"]+randi_range(
			#-Global.LevelData[Global.Level][stage][groupCount]["stageCDTand"],Global.LevelData[Global.Level][stage][groupCount]["stageCDTand"]),false).timeout
		#stage += 1 
		#firstStart()
	pass

func summonEnemy(group):
	soldierCount = Global.LevelData[Global.NowLevel][object][group]["soldier"].size()
	for j in soldierCount:
		var enemy = Global.MonsterSoldier.instantiate()
		Global.root.add_child(enemy)
		if Global.LevelData[Global.NowLevel][object][group]["stopPos"] != null:
			enemy.stopPos = Global.LevelData[Global.NowLevel][object][group]["stopPos"]
			enemy.stopTime = Global.LevelData[Global.NowLevel][object][group]["stopTime"]
		enemy.firstSetting(Global.LevelData[Global.NowLevel][object][group]["soldier"][j])
		
		if soldierCount>1: 
			await get_tree().create_timer(Global.LevelData[Global.NowLevel][object][group]["soldierCD"],false).timeout
	
	times[group] += 1
	if times[group] != Global.LevelData[Global.NowLevel][object][group]["times"]:
		await get_tree().create_timer(Global.LevelData[Global.NowLevel][object][group]["groupCD"]+randi_range(
			-Global.LevelData[Global.NowLevel][object][group]["groupCDRand"],
			Global.LevelData[Global.NowLevel][object][group]["groupCDRand"]),false).timeout
		summonEnemy(group)
	else: 
		if Global.LevelData[Global.NowLevel][object][group]["stopTime"] == -1: emit_signal("stopOver")
		if group == groupCount-1: Global.LevelOver = true
	#if stage == groupStage: summonEnemy(group,groupStage)#处于本阶段才释放本阶段士兵
	pass

