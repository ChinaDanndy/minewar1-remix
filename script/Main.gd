extends Node2D


var soldier = preload("res://sence/soldiers.tscn")
var count = 0


func _ready():
	var file = FileAccess.open("res://data/soldier.json", FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	var jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.SoldierData = jsonValue.data
	var soldierDataCount = jsonValue.data["allSoldierName"].size()
	var arrayLength
	var allSoName = jsonValue.data["allSoldierName"]
	for i in soldierDataCount:#把所有数值变成int
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
	
	
	var friend = soldier.instantiate()
	add_child(friend)
	friend.firstSetting("steve")
	
	#friend.picture = load("res://assets/soldiers/archer.png")
#	friend.picture = load("res://assets/soldiers/assassin.png")
	#friend.animationStart = [0,0,0,6,10,0,6,14]
	#friend.animationEnd = [6,0,0,10,14,0,6,14]
#	friend.animationStart = [4,0,0,12,0,0,12,19]
#	friend.animationEnd = [9,0,0,18,0,0,12,19]
#	friend.totalPictureNumber = 19
	#friend.totalPictureNumber = 15
	friend.position = Vector2(100,297)



	
	
	

	


	
	
	#_enemy()
	#count += 1
	#_enemy()
#	count += 1
#	_enemy()
#	count += 1
#	_enemy()

	
	pass

func _enemy():
	var enemy = soldier.instantiate()
	add_child(enemy)

	enemy.Health = 10
	
	if count == 0: 
		enemy.position = Vector2(250,297)
		enemy.ifUsuallyEffect = false 
		enemy.usuallyEffGoodOrBad = [1,1,1,1,1,1,1]
		enemy.usuallyEffect = [false,false,false,true,false,false,false,false,false]
		
		enemy.ifDeathEffect = false
		enemy.deathEffGoodOrBad = [1,1,1,1,1,-1,1]
		enemy.deathEffect = [false,false,false,false,false,true,false,false,false]
	if count == 1: 
		enemy.position = Vector2(270,297)
	
	if count == 2: enemy.position = Vector2(300,297)
	if count == 3: enemy.position = Vector2(300,297)
	enemy.firstSetting()
	
	pass
