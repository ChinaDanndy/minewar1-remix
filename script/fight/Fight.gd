extends Node2D
var count = 0
var summonEnemy = preload("res://script/fight/calu/summonEnemy.gd")
var summonEnemyID
var bossLv = 0

var attackTime = 0
var moneyTime = 0
var thunderTime = 0
var thunderTimeRand = 0
var caveTime = 0
var caveTimeRand = 0

var minute = 0
var second = 0

#signal cardMessage
signal reloadSence
signal fightCard
signal cardCD
signal BossLv2
signal BossLv3

func _ready():
	#Global.NowLevel = 8
	$Up/Leveltext/LeveltextValue.text = str(Global.NowLevel)
	if Global.LevelData[Global.NowLevel]["set"]["levelType"] != "boss": 
		$Boss.free()
		$bossProtect.free()
		Global.MonsterBase.camp = Global.MONSTER
		Global.MonsterBase.firstSetting("baseMonsterHealth")
	else: 
		bossLv = 1
		$baseMonster.free()
		Global.MonsterBase = $Boss
		$Boss.visible = true
		Global.BossProtect.firstSetting("boss")
	Global.VillageBase.camp = Global.VILLAGE
	Global.VillageBase.firstSetting("baseVillageHealth")#"baseVillageHealth"

	moneyTime = Global.LevelData[0]["moneySpeed"]
	Global.ThunderSpeed = Global.LevelData[0]["thunderSpeed"]
	attackTime = Global.LevelData[Global.NowLevel]["set"]["attackTime"]
	
	if Global.LevelData[Global.NowLevel]["chosenCard"].is_empty():
		Global.ChoiceWindow.visible = true
		var allMonster = []#怪物展示，自动填充目前所有有的怪物
		for i in Global.LevelData[Global.NowLevel]["groups"].size():
			for j in Global.LevelData[Global.NowLevel]["groups"][i]["soldier"]:
				if !allMonster.has(j): allMonster.append(j)	
#		if !allMonster.is_empty():
#			for i in allMonster.size():
#				var mShow = get_node("monsterShow/HBoxContainer/mShow%s"%(i+1))
#				mShow.texture = load("res://assets/objects/soldier/%s/walk/walk1.png"%allMonster[i])
		$monsterShow.visible = true
	else:
		Global.ChoiceWindow.visible =false#有给定卡不开选卡
		fightStart()#monseter 680
	pass
	
func _on_cave_timer_timeout():
	if Global.CaveHas == false:
		var tower = Global.Tower.instantiate()
		tower.camp = Global.MONSTER
		tower.firstSetting("cave")
		var pos = $monnsterTowerArea.position.x
		var size = $monnsterTowerArea.size.x/2
		tower.position.x = randi_range(pos-size,pos+size)
		Global.root.add_child(tower)
		Global.CaveHas = true
	$Timer/CaveTimer.start(caveTime+randf_range(-caveTimeRand,caveTimeRand))
	pass 
	
func _on_thundertimer_timeout():
	var targetArray = get_tree().get_nodes_in_group("creeper")
	if !targetArray.is_empty(): 
		var target = targetArray[randi_range(0,targetArray.size()-1)]
		var newthunder = Global.Skill.instantiate()
		Global.root.add_child(newthunder)
		newthunder.position.x = target.position.x-20
		newthunder.camp = Global.MONSTER
		newthunder.firstSetting("thunder")
		
	if bossLv == 3:#boss战第三阶段多一次纯劈一道闪电
		var newthunder = Global.Skill.instantiate()
		Global.root.add_child(newthunder)
		newthunder.camp = Global.MONSTER
		newthunder.firstSetting("thunder")
		newthunder.position.x = randi_range(Global.VillagePoint.x+($baseVillage.collBox.x/2),$Boss.position.x)
		
	$Timer/Thundertimer.start(thunderTime+randf_range(-thunderTimeRand,thunderTimeRand))
	pass
	
func fightStart():
	Global.CardUp = 5
	$monsterShow.visible = false
	emit_signal("fightCard")
	#await get_tree().create_timer(1,false).timeout#开局延迟开始
	emit_signal("cardCD")
	time()
	SummonEnemy()
	$Up/Moneytext.visible = true
	if bossLv < 1: $baseMonster.visible = true
	$baseVillage.visible = true#$Spacetext.visible = false
	
	if attackTime >0:
		$Up/AttackTime.visible = true
		$Timer/attackTimer.start(1)
	$Timer/Moneytimer.start(moneyTime)
	if Global.LevelData[Global.NowLevel]["set"]["caveTime"] > 0: 
		$Timer/CaveTimer.start(Global.LevelData[Global.NowLevel]["set"]["caveTime"])
	if Global.LevelData[Global.NowLevel]["set"]["thunderTime"] > 0: 
		
		$Timer/Thundertimer.start(Global.LevelData[Global.NowLevel]["set"]["thunderTime"])

	pass
	
func SummonEnemy():
	var newEnemy = summonEnemy.new()
	Global.add_child(newEnemy)
	summonEnemyID = newEnemy
	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		Global.MonsterBase.health = 0
		pass

	$Up/Moneytext/Moneycount.text = str(Global.NowMoney) +"/"+ str(Global.Money)
	if Global.NowMoney < Global.Money&&$Timer/Moneytimer.paused == true:
		$Timer/Moneytimer.paused = false
		$Timer/Moneytimer.start(moneyTime)
	$Up/TestTime/TestTimeValue.text = ("%sm%ss"%[minute,second])
	
	thunderTime = Global.LevelData[Global.NowLevel]["set"]["thunderTime"]
	thunderTimeRand = Global.LevelData[Global.NowLevel]["set"]["thunderTimeRand"]
	caveTime = Global.LevelData[Global.NowLevel]["set"]["caveTime"]
	caveTimeRand = Global.LevelData[Global.NowLevel]["set"]["caveTimeRand"]
	
	if bossLv > 0:
		$monnsterTowerArea.position.x = $Boss.global_position.x-$monnsterTowerArea.size.x-20
	if Global.VillageBase.health <= 0: Global.StopWindow.text("lose")
	if Global.MonsterBase.health <= 0: Global.StopWindow.text("win")
	match Global.LevelData[Global.NowLevel]["set"]["levelType"]:
		"defence","boss":
			if Global.LevelOver == true&&get_tree().get_nodes_in_group("monsterSoldier").is_empty(): 
				if bossLv !=  1: Global.MonsterBase.health = 0
				else:
					Global.NowLevel += 1
					bossLv = 2
					summonEnemyID.queue_free()
					SummonEnemy()
					$Timer/Thundertimer.start(thunderTime)
					$Up/AttackTime.visible = true
					$Timer/attackTimer.start(1)
					emit_signal("BossLv2")
	if bossLv == 2:
		if Global.MonsterBase.health<=Global.MonsterBase.bossSecHealth:
			Global.NowLevel += 1
			bossLv = 3
			summonEnemyID.queue_free()
			SummonEnemy()
			attackTime = Global.LevelData[Global.NowLevel]["set"]["attackTime"]
			emit_signal("BossLv3")
					
	if Global.LevelData[Global.NowLevel]["set"]["levelType"] == "attack":
		$Up/AttackTime/AttackTimeValue.text = str(attackTime)
		if attackTime <= 0: Global.VillageBase.health = 0
	pass
	
func time():
	second += 1
	if second == 60: 
		second = 0
		minute +=1
	await get_tree().create_timer(1,false).timeout
	time()
	pass
	
func _on_attack_timer_timeout(): attackTime -= 1

func _on_moneytimer_timeout():
	if Global.NowMoney < Global.Money: Global.NowMoney += 1
	if Global.NowMoney == (Global.Money): $Timer/Moneytimer.paused = true
	pass 

func _on_tree_exited():
	if summonEnemyID != null: summonEnemyID.free()
	Global.NowMoney = 0
	Global.MonsterDeaths = 0
	Global.CardBuy = null
	Global.Contrl = null
	Global.LevelOver = false
	Global.ChosenCard = [null,null,null,null,null,null]
	Global.ChosenId = [null,null,null,null,null,null]
	Global.ChosenCardNum = 0
	if bossLv > 0: Global.NowLevel = 8
	emit_signal("reloadSence")
	pass
	
func _on_tree_entered():
	Global.FightSence = self
	Global.ChoiceWindow = $Up/choiceCard
	Global.FightButton = $Up/choiceCard/fightButton
	Global.FightButton.fight.connect(fightStart)
	
#	if Global.CardUp == 4:
#		$card/HBoxContainer/CardButton5.visible = false
#		$card/HBoxContainer/CardButton6.visible = false
	if Global.CardUp == 5: $Up/card/HBoxContainer/CardButton6.visible = false
	#Global.StopWindowLayer = $StopWindowLayer
	
	Global.FightGroundY = $position/ground.position.y
	Global.FightSkyY = $position/sky.position.y
	Global.VillagePoint = $position/VillagePoint.position
	Global.MonsterPoint = $position/MonsterPoint.position#740
	Global.VillageBase = $baseVillage/collBox
	Global.MonsterBase = $baseMonster/collBox
	
	Global.BossProtect = $bossProtect/collBox
	Global.BossProtect.camp = Global.MONSTER
	Global.BossStopX = $position/bossStop.position.x
	Global.BossPosX = $position/bossPos.position.x
	
	Global.towerArea = $towerArea
	Global.towerArea.visible = false
	Global.skillArea = $skillArea
	Global.skillArea.visible = false
	Global.StopON = false
	
	$Up/Moneytext.visible = false
	$Spacetext.visible = false
	$Up/AttackTime.visible = false
	$baseMonster.visible = false
	$baseVillage.visible = false
	$bossProtect.visible = false
	$Boss.visible = false
	pass











