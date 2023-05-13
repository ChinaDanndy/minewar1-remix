extends Node2D
var count = 0
var summonEnemy = preload("res://script/fight/calu/summonEnemy.gd")
var summonEnemyID

var attackTime
var moneyTime
var thunderTime
var thunderTimeRand

signal cardMessage
signal reloadSence
func _ready():
	var file = FileAccess.open("res://data/object.json", FileAccess.READ)#user:
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
		
		var pictureGet#提前根据图片得到单位碰撞箱尺寸
		if Global.STSData[STSName]["type"] == "soldier":
			pictureGet = load("res://assets/objects/soldier/%s/attack/attack1.png"% STSName)
		if Global.STSData[STSName]["type"] == "tower":
			pictureGet = load("res://assets/objects/tower/%s/stop/stop1.png"% STSName)
		if Global.STSData[STSName]["type"] == "skill":
			pictureGet = load("res://assets/objects/skill/%s.png"% STSName)
		Global.STSData[STSName]["collBox"] = pictureGet.get_size()

	file = FileAccess.open("res://data/level.json", FileAccess.READ)
	content = file.get_as_text()
	file.close()
	jsonValue = JSON.new()
	jsonValue.parse(content)
	Global.LevelData = jsonValue.data
	
	moneyTime = Global.LevelData[0]["moneySpeed"]
	$Moneytimer.start(moneyTime)
	
	Global.ThunderSpeed = Global.LevelData[0]["thunderSpeed"]
	thunderTime = Global.LevelData[Global.Level][0]["thunderTime"]
	thunderTimeRand = Global.LevelData[Global.Level][0]["thunderTimeRand"]
	if thunderTime >0: $Thundertimer.start(thunderTime+randi_range(-thunderTimeRand,thunderTimeRand))
	
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
		
	emit_signal("cardMessage")#monseter 680

	var newEnemy = summonEnemy.new()
	Global.Level = 1
	Global.root.call_deferred("add_child",newEnemy)
	newEnemy.call_deferred("firstStart")
	newEnemy.name = "summonEnemy"
	summonEnemyID = newEnemy
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
	$Thundertimer.start(thunderTime+randi_range(-thunderTimeRand,thunderTimeRand))
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		Global.MonsterBase.health = 0
		pass
	
#	if Global.MonsterDeaths >= 1:
#		var tower = Global.Tower.instantiate()
#		Global.root.add_child(tower)
#		tower.camp = Global.MONSTER
#		tower.unPeopleFly = false
#		tower.position = Global.MonsterPoint
#		tower.firstSetting("cave")
#		Global.MonsterDeaths = 0
	$Moneytext/Moneycount.text = str(Global.NowMoney) +"/"+ str(Global.Money)
	if Global.NowMoney != Global.Money&&$Moneytimer.one_shot == true:
		$Moneytimer.start(moneyTime)
	$AttackTime/AttackTimeValue.text = str(attackTime)

	match Global.LevelData[Global.Level][0]["levelType"]:
		Global.LevelType.ATTACK:
			if attackTime <=0:#loss
				if Global.MonsterBase.health > 0: Global.StopWindow.text("lose")
			else: if Global.MonsterBase.health <= 0: Global.StopWindow.text("win")
		Global.LevelType.ATTDEF:
			if Global.MonsterBase.health <= 0: Global.StopWindow.text("win")
			if Global.VillageBase.health <= 0: Global.StopWindow.text("lose")
		Global.LevelType.DEFENCE:
			if Global.VillageBase.health <= 0: Global.StopWindow.text("lose")
			if Global.LevelOver == true&&get_tree().get_nodes_in_group("monsterSoldier").is_empty():
				Global.StopWindow.text("win")
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
	summonEnemyID.queue_free()
	Global.NowMoney = 0
	Global.MonsterDeaths = 0
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
	Global.FightSkyY = $sky.position.y
	Global.VillagePoint = $VillagePoint.position
	Global.MonsterPoint = $MonsterPoint.position#740
	
	Global.VillageBase = $baseVillage/collBox
	Global.MonsterBase = $baseMonster/collBox
	Global.towerArea = $towerArea
	#Global.towerArea.visible = false
	Global.skillArea = $skillArea
	#Global.skillArea.visible = false
	Global.StopON = false
	pass








