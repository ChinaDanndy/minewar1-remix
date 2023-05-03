extends Node2D
var count = 0
var summonEnemy = preload("res://script/summonEnemy.gd")
var summonEnemyID
var cardLength = 7
signal cardMessage
signal reloadSence

func _ready():
	
	var file = FileAccess.open("res://data/soldier.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()#读取所有士兵数据
	
	var jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.STSData = jsonValue.data
	var arrayLength
	var pictureGet
	for STSName in jsonValue.data:#把所有数值变成int,数组要挨个把里面的值重新读
		for STSDatename in Global.STSData[STSName]:
			if Global.STSDataName.has(STSDatename):
				match Global.STSDataName[STSDatename]:
					Global.STSType.INT: Global.STSData[STSName][STSDatename] = int(jsonValue.data[STSName][STSDatename])
					Global.STSType.ARRAY: 
						arrayLength = Global.STSData[STSName][STSDatename].size()
						for i in arrayLength:
							Global.STSData[STSName][STSDatename][i] = int(jsonValue.data[STSName][STSDatename][i])
		pictureGet = load("res://assets/soldiers/"+STSName+".png")#提前根据图片得到单位碰撞箱尺寸
		Global.STSData[STSName]["collBox"] = Vector2(0,0)
		Global.STSData[STSName]["collBox"].x = int(round(pictureGet.get_width()/Global.STSData[STSName]["totalPictureNumber"]))
		Global.STSData[STSName]["collBox"].y = int(pictureGet.get_height())

		

	file = FileAccess.open("res://data/level.json", FileAccess.READ)
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
				if k == groupCount-1:
					Global.LevelData[i][j][k]["stageCD"] = int(jsonValue.data[i][j][k]["stageCD"])
					Global.LevelData[i][j][k]["stageCDTand"] = int(jsonValue.data[i][j][k]["stageCDTand"])
				else:
					Global.LevelData[i][j][k]["firstCD"] = int(jsonValue.data[i][j][k]["firstCD"])
					Global.LevelData[i][j][k]["CDType"] = int(jsonValue.data[i][j][k]["CDType"])
					Global.LevelData[i][j][k]["groupCD"] = int(jsonValue.data[i][j][k]["groupCD"])
					Global.LevelData[i][j][k]["groupCDRand"] = int(jsonValue.data[i][j][k]["groupCDRand"])
	
	emit_signal("cardMessage")
	$Moneytimer.start(Global.MoneyTime)


	var newEnemy = summonEnemy.new()
	Global.Level = 0
	Global.root.call_deferred("add_child",newEnemy)
	newEnemy.call_deferred("firstStart")
	summonEnemyID = newEnemy
	
	
	
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
	$Moneycount.text = str(Global.NowMoney) +"/"+ str(Global.Money)
	if Global.NowMoney != Global.Money&&$Moneytimer.one_shot == true:
		$Moneytimer.one_shot = false
		$Moneytimer.start()
	pass
	

func _on_moneytimer_timeout():
	if Global.NowMoney < Global.Money:
		Global.NowMoney += 1
	if Global.NowMoney == (Global.Money-1): $Moneytimer.one_shot = true
	pass 

#
	pass

func _on_tree_exited():
	summonEnemyID.queue_free()
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
	Global.towerArea = $towerArea
	Global.towerArea.visible = false
	Global.skillArea = $skillArea
	Global.skillArea.visible = false

	pass # Replace with function body.
