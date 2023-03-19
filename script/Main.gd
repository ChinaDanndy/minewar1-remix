extends Node2D



var count = 0

var card = preload("res://sence/Card.tscn")
var summonEnemy = preload("res://script/summonEnemy.gd")
var base = preload("res://sence/Base.tscn")


func _ready():
	var file = FileAccess.open("res://data/soldier.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()#读取所有士兵数据
	var jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.SoldierData = jsonValue.data
	
	var soldierDataCount = jsonValue.data["allSoldierName"].size()
	var arrayLength
	var allSoName = jsonValue.data["allSoldierName"]
	for i in soldierDataCount:#把所有数值变成int,数组要挨个把里面的值重新读
		Global.SoldierData[allSoName[i]]["price"] = int(jsonValue.data[allSoName[i]]["price"])
		Global.SoldierData[allSoName[i]]["camp"] = int(jsonValue.data[allSoName[i]]["camp"])
		Global.SoldierData[allSoName[i]]["kind"] = int(jsonValue.data[allSoName[i]]["kind"])
		Global.SoldierData[allSoName[i]]["collKind"] = int(jsonValue.data[allSoName[i]]["collKind"])
		Global.SoldierData[allSoName[i]]["health"] = int(jsonValue.data[allSoName[i]]["health"])
		Global.SoldierData[allSoName[i]]["totalPictureNumber"] = int(jsonValue.data[allSoName[i]]["totalPictureNumber"])
		arrayLength = jsonValue.data[allSoName[i]]["animationStart"].size()
		
		for j in arrayLength:
			Global.SoldierData[allSoName[i]]["animationStart"][j] = int(jsonValue.data[allSoName[i]]["animationStart"][j])
		
		arrayLength = jsonValue.data[allSoName[i]]["animationEnd"].size()
		for j in arrayLength:
			Global.SoldierData[allSoName[i]]["animationEnd"][j] = int(jsonValue.data[allSoName[i]]["animationEnd"][j])
		Global.SoldierData[allSoName[i]]["seaAniNumber"] = int(jsonValue.data[allSoName[i]]["seaAniNumber"])
		Global.SoldierData[allSoName[i]]["damageMethod"] = int(jsonValue.data[allSoName[i]]["damageMethod"])
		Global.SoldierData[allSoName[i]]["damageBasic"] = int(jsonValue.data[allSoName[i]]["damageBasic"])
		Global.SoldierData[allSoName[i]]["attRangeBasic"] = int(jsonValue.data[allSoName[i]]["attRangeBasic"])
		arrayLength = jsonValue.data[allSoName[i]]["aoeModel"].size()
		for j in arrayLength:
			Global.SoldierData[allSoName[i]]["aoeModel"][j] = int(jsonValue.data[allSoName[i]]["aoeModel"][j])
		
		arrayLength = jsonValue.data[allSoName[i]]["aoeRange"].size()
		for j in arrayLength:
			Global.SoldierData[allSoName[i]]["aoeRange"][j] = int(jsonValue.data[allSoName[i]]["aoeRange"][j])

		arrayLength = jsonValue.data[allSoName[i]]["attEffGoodOrBad"].size()
		for j in arrayLength:
			Global.SoldierData[allSoName[i]]["attEffGoodOrBad"][j] = int(jsonValue.data[allSoName[i]]["attEffGoodOrBad"][j])

		arrayLength = jsonValue.data[allSoName[i]]["usuallyEffGoodOrBad"].size()
		for j in arrayLength:
			Global.SoldierData[allSoName[i]]["usuallyEffGoodOrBad"][j] = int(jsonValue.data[allSoName[i]]["usuallyEffGoodOrBad"][j])

		arrayLength = jsonValue.data[allSoName[i]]["deathEffGoodOrBad"].size()
		for j in arrayLength:
			Global.SoldierData[allSoName[i]]["deathEffGoodOrBad"][j] = int(jsonValue.data[allSoName[i]]["deathEffGoodOrBad"][j])
		Global.SoldierData[allSoName[i]]["healthEffValue"] = int(jsonValue.data[allSoName[i]]["healthEffValue"])
		Global.SoldierData[allSoName[i]]["healthDefValue"] = int(jsonValue.data[allSoName[i]]["healthDefValue"])
		Global.SoldierData[allSoName[i]]["satDefValue"] = int(jsonValue.data[allSoName[i]]["satDefValue"])
	
	file = FileAccess.open("res://data/level.json", FileAccess.READ)
	content = file.get_as_text()
	file.close()
	jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.LevelData = jsonValue.data
	var levelDateCount = jsonValue.data.size()
	for i in levelDateCount:
		var stageCount = jsonValue.data[i].size()
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
	

	
	var Card = card.instantiate()
	add_child(Card)
	Card.position = Vector2(100,360)
	Card.firstSetting("steve")
	
	var newEnemy = summonEnemy.new()
	add_child(newEnemy)
	newEnemy.level = 0
	newEnemy.firstStart()
	
	var BaseVill = base.instantiate()
	add_child(BaseVill)
	BaseVill.position = Vector2(100,270)
	BaseVill.collision_layer = 16
	BaseVill.picture(Global.VILLAGE)
	
	var BaseMon = base.instantiate()
	add_child(BaseMon)
	BaseMon.position = Vector2(700,270)
	BaseMon.collision_layer = 32
	BaseMon.picture(Global.MONSTER)
	#friend.picture = load("res://assets/soldiers/archer.png")
#	friend.picture = load("res://assets/soldiers/assassin.png")
	#friend.animationStart = [0,0,0,6,10,0,6,14]
	#friend.animationEnd = [6,0,0,10,14,0,6,14]
#	friend.animationStart = [4,0,0,12,0,0,12,19]
#	friend.animationEnd = [9,0,0,18,0,0,12,19]
#	friend.totalPictureNumber = 19
	#friend.totalPictureNumber = 15
	
func _physics_process(delta):
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


