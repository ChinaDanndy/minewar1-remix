extends Node2D
var count = 0
var summonEnemy = preload("res://script/summonEnemy.gd")
var summonEnemyID
var cardLength = 7
var attackTime
var moneyTime
var thunderTime
var thunderTimeRand
signal cardMessage
signal reloadSence
func _ready():

	var file = FileAccess.open("user://soldier.json", FileAccess.READ)#user:
	var content = file.get_as_text()
	file = null #读取所有士兵数据
	
	var jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.STSData = jsonValue.data
	var arrayLength

	for STSName in jsonValue.data:#把所有数值变成int,数组要挨个把里面的值重新读
		for STSDatename in Global.STSData[STSName]:
			if Global.STSDataName.has(STSDatename):
				match Global.STSDataName[STSDatename]:
					Global.STSType.INT: 
						Global.STSData[STSName][STSDatename] = int(jsonValue.data[STSName][STSDatename])
					Global.STSType.ARRAY: 
						arrayLength = Global.STSData[STSName][STSDatename].size()
						for i in arrayLength:
							Global.STSData[STSName][STSDatename][i] = int(jsonValue.data[STSName][STSDatename][i])

		#提前根据图片得到单位碰撞箱尺寸
		var pictureGet
		match Global.STSData[STSName]["type"]:
			Global.Type.SOLDIER: pictureGet = load("res://assets/objects/soldier/%s/attack/attack1.png"% STSName)
			Global.Type.TOWER: pictureGet = load("res://assets/objects/tower/%s/attack/attack1.png"% STSName)
			Global.Type.SKILL: pictureGet = load("res://assets/objects/skill/%s.png"% STSName)
		Global.STSData[STSName]["collBox"] = pictureGet.get_size()

	file = FileAccess.open("user://level.json", FileAccess.READ)
	content = file.get_as_text()
	file.close()
	jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.LevelData = jsonValue.data
	#var levelDateCount = jsonValue.data.size()
	#for i in levelDateCount:
		#var stageCount = jsonValue.data[i].size()-1
		#for j in stageCount:
			#var groupCount = jsonValue.data[i][j].size()
			#for k in groupCount:
				#if k == groupCount-1:pass
					#Global.LevelData[i][j][k]["stageCD"] = int(jsonValue.data[i][j][k]["stageCD"])
					#Global.LevelData[i][j][k]["stageCDTand"] = int(jsonValue.data[i][j][k]["stageCDTand"])
				#else: pass
					#Global.LevelData[i][j][k]["firstCD"] = int(jsonValue.data[i][j][k]["firstCD"])
					#Global.LevelData[i][j][k]["CDType"] = int(jsonValue.data[i][j][k]["CDType"])
					#Global.LevelData[i][j][k]["times"] = int(jsonValue.data[i][j][k]["times"])
					#Global.LevelData[i][j][k]["stopPos"] = int(jsonValue.data[i][j][k]["stopPos"])	
					#Global.LevelData[i][j][k]["groupCD"] = int(jsonValue.data[i][j][k]["groupCD"])
					#Global.LevelData[i][j][k]["groupCDRand"] = int(jsonValue.data[i][j][k]["groupCDRand"])
	
	moneyTime = Global.LevelData[0]["moneySpeed"]
	Global.ThunderSpeed = Global.LevelData[0]["thunderSpeed"]
	thunderTime = Global.LevelData[Global.Level][0]["thunderTime"]
	thunderTimeRand = Global.LevelData[Global.Level][0]["thunderTimeRand"]
	Global.VillageBase.camp = Global.VILLAGE
	Global.VillageBase.firstSetting("baseVillageHealth")
	Global.MonsterBase.camp = Global.MONSTER
	Global.MonsterBase.firstSetting("baseMonsterHealth")
	Global.LevelData[Global.Level][0]["levelType"] = int(Global.LevelData[Global.Level][0]["levelType"])
	match Global.LevelData[Global.Level][0]["levelType"]:
		Global.LevelType.ATTACK: 
			$baseVillage/Label.visible = false 
			attackTime = Global.LevelData[Global.Level][0]["attackTime"]
			$AttackTime.visible = true
			$attackTimer.start(1)
		Global.LevelType.DEFENCE: $baseMonster/Label.visible = false 
	if thunderTime >0: $Thundertimer.start(thunderTime+randi_range(-thunderTimeRand,thunderTimeRand))
	emit_signal("cardMessage")#monseter 680
	$Moneytimer.start(Global.MoneyTime)

	var newEnemy = summonEnemy.new()
	Global.Level = 1
	Global.root.call_deferred("add_child",newEnemy)
	newEnemy.call_deferred("firstStart")
	newEnemy.name = "summonEnemy"
	Global.SummonEnemy = newEnemy
	pass
	
func _on_thundertimer_timeout():
	var targetArray = get_tree().get_nodes_in_group("creeper")
	if !targetArray.is_empty(): 

		var target = targetArray[randi_range(0,targetArray.size()-1)]
		var newthunder = Global.Skill.instantiate()
		Global.root.add_child(newthunder)
		newthunder.camp = Global.MONSTER
		newthunder.firstSetting("thunder")
		newthunder.position.y = Global.FightGroundY-(Global.STSData["thunder"]["collBox"].y/2)
		newthunder.position.x = target.position.x-20
	print("aaa")
	$Thundertimer.start(thunderTime+randi_range(-thunderTimeRand,thunderTimeRand))
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		Global.MonsterBase.health = 0

		pass
	$Moneytext/Moneycount.text = str(Global.NowMoney) +"/"+ str(Global.Money)
	if Global.NowMoney != Global.Money&&$Moneytimer.one_shot == true:
		$Moneytimer.start(moneyTime)
	$AttackTime/AttackTimeValue.text = str(attackTime)
	#print(Global.LevelData[Global.Level][0]["levelType"])
	match Global.LevelData[Global.Level][0]["levelType"]:
		Global.LevelType.ATTACK:
			if attackTime <=0:#loss
				if Global.MonsterBase.health > 0:
					Global.StopWindow.text("lose")
					get_tree().paused = true
			else:
				if Global.MonsterBase.health <= 0:
					Global.StopWindow.text("win")
					get_tree().paused = true
		Global.LevelType.ATTDEF:
			if Global.MonsterBase.health<=0:
				Global.StopWindow.text("win")
				get_tree().paused = true
			if Global.VillageBase.health<=0:
				Global.StopWindow.text("lose")
				get_tree().paused = true
		Global.LevelType.DEFENCE:
			if Global.VillageBase.health<=0:
				Global.StopWindow.text("lose")
				get_tree().paused = true
			if Global.LevelOver == true&&get_tree().get_nodes_in_group("monsterSoldier").is_empty():
				Global.StopWindow.text("win")
				get_tree().paused = true
	pass
	
func _on_attack_timer_timeout():
	if attackTime>0: attackTime -= 1
	pass

func _on_moneytimer_timeout():
	if Global.NowMoney < Global.Money:
		Global.NowMoney += 1
	if Global.NowMoney == (Global.Money-1): $Moneytimer.one_shot = true
	pass 

func _on_tree_exited():
	Global.SummonEnemy.queue_free()
	Global.NowMoney = 0
	Global.CardBuy = null
	Global.Contrl = null
	emit_signal("reloadSence")
	pass
	
func _on_tree_entered():
	Global.StopButton = $StopButton
	Global.StopWindowLayer = $StopWindowLayer
	Global.StopWindow = $StopWindowLayer/StopWindow
	Global.FightSence = self
	Global.FightGroundY = $ground.position.y
	Global.VillagePoint = $VillagePoint
	Global.MonsterPoint = $MonsterPoint
	Global.VillageBase = $baseVillage/CharacterBody2D
	Global.MonsterBase = $baseMonster/CharacterBody2D
	Global.towerArea = $towerArea
	Global.towerArea.visible = false
	Global.skillArea = $skillArea
	Global.skillArea.visible = false
	pass








