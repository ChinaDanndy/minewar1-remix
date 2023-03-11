extends Node2D



var count = 0

var card = preload("res://sence/Card.tscn")
var summonEnemy = preload("res://script/summonEnemy.gd")


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
	


	
	var Card = card.instantiate()
	add_child(Card)
	Card.position = Vector2(100,360)
	Card.firstSetting("steve")
	
	var newEnemy = summonEnemy.new()
	add_child(newEnemy)
	newEnemy.firstStart()
	
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


