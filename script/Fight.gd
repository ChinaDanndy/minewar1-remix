extends Node2D
var count = 0
var summonEnemy = preload("res://script/summonEnemy.gd")
var test = preload("res://sence/villageSoldier.tscn")
var summonEnemyID
var cardLength = 7
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
					Global.STSType.INT: Global.STSData[STSName][STSDatename] = int(jsonValue.data[STSName][STSDatename])
					Global.STSType.ARRAY: 
						arrayLength = Global.STSData[STSName][STSDatename].size()
						for i in arrayLength:
							Global.STSData[STSName][STSDatename][i] = int(jsonValue.data[STSName][STSDatename][i])
		#提前根据图片得到单位碰撞箱尺寸
		var pictureGet =  load("res://assets/objects/%s/stop/stop1.png"% STSName)
		Global.STSData[STSName]["collBox"] = pictureGet.get_size()

		

	file = FileAccess.open("user://level.json", FileAccess.READ)
	content = file.get_as_text()
	file.close()
	jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.LevelData = jsonValue.data
	var levelDateCount = jsonValue.data.size()
	for i in levelDateCount:
		var stageCount = jsonValue.data[i].size()-1
		for j in stageCount:
			var groupCount = jsonValue.data[i][j].size()
			for k in groupCount:
				if k == groupCount-1:pass
					#Global.LevelData[i][j][k]["stageCD"] = int(jsonValue.data[i][j][k]["stageCD"])
					#Global.LevelData[i][j][k]["stageCDTand"] = int(jsonValue.data[i][j][k]["stageCDTand"])
				else: pass
					#Global.LevelData[i][j][k]["firstCD"] = int(jsonValue.data[i][j][k]["firstCD"])
					#Global.LevelData[i][j][k]["CDType"] = int(jsonValue.data[i][j][k]["CDType"])
					#Global.LevelData[i][j][k]["times"] = int(jsonValue.data[i][j][k]["times"])
					#Global.LevelData[i][j][k]["stopPos"] = int(jsonValue.data[i][j][k]["stopPos"])	
					#Global.LevelData[i][j][k]["groupCD"] = int(jsonValue.data[i][j][k]["groupCD"])
					#Global.LevelData[i][j][k]["groupCDRand"] = int(jsonValue.data[i][j][k]["groupCDRand"])
	
	emit_signal("cardMessage")#monseter 680
	$Moneytimer.start(Global.MoneyTime)


	var newEnemy = summonEnemy.new()
	Global.Level = 0
	Global.root.call_deferred("add_child",newEnemy)
	newEnemy.call_deferred("firstStart")
	Global.SummonEnemy = newEnemy
	
	
	
	#friend.picture = load("res://assets/soldiers/archer.png")
#	friend.picture = load("res://assets/soldiers/assassin.png")
	#friend.animationStart = [0,0,0,6,10,0,6,14]
	#friend.animationEnd = [6,0,0,10,14,0,6,14]
#	friend.animationStart = [4,0,0,12,0,0,12,19]
#	friend.animationEnd = [9,0,0,18,0,0,12,19]
#	friend.totalPictureNumber = 19
	#friend.totalPictureNumber = 15
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var Test = test.instantiate()
		Global.root.add_child(Test)
		Test.firstSetting("shielder")
		Test.position = Global.VillagePoint.position#100
	$Moneycount.text = str(Global.NowMoney) +"/"+ str(Global.Money)
	if Global.NowMoney != Global.Money&&$Moneytimer.one_shot == true:
		$Moneytimer.one_shot = false
		$Moneytimer.start()
	match Global.LevelData[Global.Level][0]["levelType"]:
		#Global.LevelType.ATTACK:
			

		Global.LevelType.ATTDEF:
			if Global.MonsterBase.health<=0:
				Global.StopWindow.text("win")
				get_tree().paused = true
			if Global.VillageBase.health<=0:
				Global.StopWindow.text("lose")
				get_tree().paused = true
		#Global.LevelType.DEFENCE:
			
	#if health<=0&&Global.LevelData[Global.Level][0]["levelType"] == Global.LevelType.ATTDEF: #胜负判断
		#Global.StopWindowLayer.visible = true
		#if camp == Global.VILLAGE: Global.StopWindow.text("lose")
		#if camp == Global.MONSTER: Global.StopWindow.text("win")
		#get_tree().paused = true
	pass
	

func _on_moneytimer_timeout():
	if Global.NowMoney < Global.Money:
		Global.NowMoney += 1
	if Global.NowMoney == (Global.Money-1): $Moneytimer.one_shot = true
	pass 

#
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
	Global.VillageBase = $BaseVill
	Global.MonsterBase = $BaseMon
	Global.towerArea = $towerArea
	Global.towerArea.visible = false
	Global.skillArea = $skillArea
	Global.skillArea.visible = false

	pass # Replace with function body.
