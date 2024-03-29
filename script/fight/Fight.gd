extends Node2D

var summonEnemy = preload("res://script/fight/calu/summonEnemy.gd")
var summonEnemyID
var bossLv = 0
var bossShineSet = 0
var bossUp = 0
var villageBaseHealth = 20

var gameOver = false
var levelType
var levelTarget
var attackTime = 0
var moneyTime = 0
var thunderTime = 0
var thunderTimeRand = 0
var iceTime = 0
var iceTimeRand = 0

var minute = 0
var second = 0

signal reloadSence
signal monsterShowLoad
signal fightCard
signal cardCD
signal BossLv2
signal BossLv3

func _ready():
	#Global.NowLevel = 11
	if Global.NowLevel <= 4:#换背景
		$backGround1.visible = true
		$Up/buttom1.visible = true
	else:
		$backGround2.visible = true
		$Up/buttom2.visible = true
	
	levelType = Global.LevelData[Global.NowLevel]["set"]["levelType"]
	levelTarget = Global.STSData[levelType]["objectName"]
	$Up/LevelMessage/Leveltext.text = ("第%s关"%Global.NowLevel)
	$Up/LevelMessage/LevelType.text = levelTarget
	
	if levelType != "boss": 
		$Boss.free()
		$bossProtect.free()
		Global.MonsterBase.camp = Global.MONSTER
		Global.MonsterBase.firstSetting()
	else: 
		bossLv = 1
		$baseMonster.free()
		Global.MonsterBase = $Boss
		$Boss.visible = true
		Global.BossProtect.firstSetting()
	Global.VillageBase.camp = Global.VILLAGE
	Global.VillageBase.firstSetting()
	moneyTime = Global.LevelData[0]["moneySpeed"]
	
	if Global.LevelData[Global.NowLevel]["chosenCard"].is_empty():
		Global.ChoiceWindow.visible = true
		if Global.LevelData[Global.NowLevel]["set"]["levelType"] != "boss":
			var count = 0#怪物展示，自动填充目前所有有的怪物
			Global.AllMonster = [null,null,null,null,null,null,null]
			for i in Global.LevelData[Global.NowLevel]["groups"].size():
				for j in Global.LevelData[Global.NowLevel]["groups"][i]["soldier"]:
					if !Global.AllMonster.has(j): 
						Global.AllMonster[count] = j
						count += 1
			#if Global.NowLevel == 6||Global.NowLevel == 7: Global.AllMonster[5] = "creeper"
			if Global.LevelData[Global.NowLevel]["set"]["iceTime"] > 0: 
				Global.AllMonster[6] = "ice"
			if Global.LevelData[Global.NowLevel]["set"]["thunderTime"] > 0: 
				Global.AllMonster[6] = "thunder"
			emit_signal("monsterShowLoad")
			$monsterShow.visible = true
	else:
		Global.ChoiceWindow.visible =false#有给定卡不开选卡
		emit_signal("fightCard")
		fightStart()#monseter 680
	pass
	
func _on_cave_timer_timeout():
	var targetArray = get_tree().get_nodes_in_group("villageSoldier")
	if !targetArray.is_empty(): 
		var target = targetArray[randi_range(0,targetArray.size()-1)]
		var newIce = Global.Skill.instantiate()
		if target.velocity == 0:
			newIce.position.x = target.global_position.x
		else: newIce.position.x = target.global_position.x+50
		newIce.camp = Global.MONSTER
		Global.root.add_child(newIce)
		newIce.firstSetting("ice")
		$Timer/CaveTimer.start(iceTime+randf_range(-iceTimeRand,iceTimeRand))
	else: $Timer/CaveTimer.start(0.5)
	pass 
	
func _on_thundertimer_timeout():
#	var targetArray = get_tree().get_nodes_in_group("creeper")
#	if !targetArray.is_empty(): 
#		var target = targetArray[randi_range(0,targetArray.size()-1)]
#		var newtThunder = Global.Skill.instantiate()
#		newtThunder.position.x = target.position.x-20
#		newtThunder.camp = Global.MONSTER
#		Global.root.add_child(newtThunder)
#		newtThunder.firstSetting("thunder")
		
#	if bossLv == 3:#boss战第三阶段多一次纯劈一道闪电
	var targetArray1 = get_tree().get_nodes_in_group("villageSoldier")
	if !targetArray1.is_empty(): 
		var target1 = targetArray1[randi_range(0,targetArray1.size()-1)]
		var newtThunder = Global.Skill.instantiate()
		newtThunder.camp = Global.MONSTER
		if target1.velocity == 0:
			newtThunder.position.x = target1.global_position.x
		else: newtThunder.position.x = target1.global_position.x+25
		Global.root.add_child(newtThunder)
		newtThunder.firstSetting("thunder")
		$Timer/ThunderTimer.start(thunderTime+
		randf_range(-thunderTimeRand,thunderTimeRand))
	else: $Timer/ThunderTimer.start(0.5)
	pass
	
func fightStart():
#	for i in 10:
#		var friend = Global.Soldier.instantiate()
#		friend.camp = Global.VILLAGE
#		Global.root.add_child(friend)
#		friend.firstSetting("shoveler")
	
	time()
	SummonEnemy()
	$monsterShow.visible = false
	$Up/MoneyMessage.visible = true
	$Timer/Moneytimer.start(moneyTime)
	if Global.LevelData[Global.NowLevel]["set"]["iceTime"] > 0: 
		$Timer/CaveTimer.start(Global.LevelData[Global.NowLevel]["set"]["iceTime"])
	if Global.LevelData[Global.NowLevel]["set"]["thunderTime"] > 0: 
		$Timer/ThunderTimer.start(Global.LevelData[Global.NowLevel]["set"]["thunderTime"])
	pass
	
func SummonEnemy():
	var newEnemy = summonEnemy.new()
	Global.add_child(newEnemy)
	summonEnemyID = newEnemy
	pass
	
func _process(_delta):
	if Input.is_action_pressed("contrl_all"):
		Global.ContrlType = Global.Con.ALL#全体士兵
		Global.Contrl = null
	if Input.is_action_just_pressed("ui_test"):
		#print(Global.test)
		#print(get_tree().get_nodes_in_group("villageSoldier"))
		#Global.MonsterBase.health = 0
		pass
#	if Input.is_action_just_pressed("contrl1"): Global.Contrl = "shoveler"
#	if Input.is_action_just_pressed("contrl2"): Global.Contrl = "shielder"
#	if Input.is_action_just_pressed("contrl3"): Global.Contrl = "snowman"
#	if Input.is_action_just_pressed("contrl4"): Global.Contrl = "flyer"
#	if Input.is_action_just_pressed("contrl5"): Global.Contrl = "iron"
	
	$skillArea.size.x = Global.MonsterPoint.x-Global.VillagePoint.x
	#技能释放位置固定
	$Up/MoneyMessage/Moneycount.text = ("%s/%s"%[Global.NowMoney,Global.Money])
	if Global.NowMoney < Global.Money&&$Timer/Moneytimer.paused == true:
		$Timer/Moneytimer.paused = false
		$Timer/Moneytimer.start(moneyTime)
	$Up/TestTime/TestTimeValue.text = ("%sm%ss"%[minute,second])
	
	thunderTime = Global.LevelData[Global.NowLevel]["set"]["thunderTime"]
	thunderTimeRand = Global.LevelData[Global.NowLevel]["set"]["thunderTimeRand"]
	iceTime = Global.LevelData[Global.NowLevel]["set"]["iceTime"]
	iceTimeRand = Global.LevelData[Global.NowLevel]["set"]["iceTimeRand"]
	
	if gameOver == false:
		$StopButton.button_mask = MOUSE_BUTTON_MASK_LEFT
		$teachButton.button_mask = MOUSE_BUTTON_MASK_LEFT
		if Global.VillageBase.health <= 0: 
			gameOver = true
			await get_tree().create_timer(0.6).timeout
			Global.StopWindow.text("lose")
		if Global.MonsterBase.health <= 0: 
			gameOver = true
			await get_tree().create_timer(0.6).timeout
			Global.StopWindow.text("win")
	else:
		$StopButton.button_mask = 0
		$teachButton.button_mask = 0
#	if bossLv > 0:
#		$monnsterTowerArea.position.x = (
#			$Boss.global_position.x-$monnsterTowerArea.size.x-20)
	match levelType:
		"defence","boss":
			if Global.LevelOver == true&&get_tree().get_nodes_in_group("monsterSoldier").is_empty(): 
				if levelType ==  "defence"&&Global.MonsterBase.health>0: 
					Global.MonsterBase.health = 0
				if levelType ==  "boss"&&bossLv == 1: 
					Global.NowLevel += 1
					bossLv = 2
					summonEnemyID.queue_free()
					emit_signal("BossLv2")
					#$Timer/ThunderTimer.start(thunderTime)
	pass
	
func time():
	second += 1
	if second == 60: 
		second = 0
		minute +=1
	await get_tree().create_timer(1,false).timeout
	time()
	pass

func _on_attack_timer_timeout(): 
	attackTime -= 1
	bossUp += 1
	pass

func _on_moneytimer_timeout():
	if Global.NowMoney < Global.Money: Global.NowMoney += 1
	if Global.NowMoney == (Global.Money): $Timer/Moneytimer.paused = true
	pass 

func _on_tree_exited():
	if summonEnemyID != null: summonEnemyID.free()
	if bossLv > 0: Global.NowLevel = 8
	emit_signal("reloadSence")
	pass
	
func _on_tree_entered():
	Global.FightSence = self
	Global.NowMoney = 0
	Global.CardBuy = null
	Global.Contrl = null
	Global.ContrlType = Global.Con.GROUP
	Global.LevelOver = false
	
	Global.VillageBase = $baseVillage/collBox
	Global.MonsterBase = $baseMonster/collBox
	Global.VillageBase.health = 20 
	if Global.Brought["baseUpdate"] == true: Global.VillageBase.health = 35#基地血量升级
	if Global.Level <= 5: Global.CardUp = Global.Level+1
	else: Global.CardUp = 6
	if Global.Brought["cardUpdate"] == true: Global.CardUp += 1#卡槽升级
	Global.Money = 10
	if Global.Brought["moneyUpate"] == true: Global.Money = 15#资金上限升级
	
	Global.ChosenCard = [null,null,null,null,null,null,null]
	Global.ChosenId = [null,null,null,null,null,null,null]
	Global.ChosenCardNum = 0
	Global.ChoiceWindow = $choiceCard
	Global.CardTextWindow = $cardTextWindow
	Global.FightButton = $choiceCard/fightButton
	Global.FightButton.fight.connect(fightStart)
	
	Global.FightGroundY = $position/ground.position.y
	Global.FightSkyY = $position/sky.position.y
	Global.VillagePoint = $position/VillagePoint.position
	Global.MonsterPoint = $position/MonsterPoint.position#740
	
	Global.Boss = $Boss
	Global.BossProtect = $bossProtect/collBox
	Global.BossProtect.camp = Global.MONSTER
	Global.BossSkill = $bossSkill
	Global.BossSkill.position.y = Global.FightSkyY
	Global.BossSkill.frame = 0
	Global.BossPosX = $position/bossPos.position.x
	
	Global.towerArea = $towerArea
	Global.towerArea.visible = false
	Global.skillArea = $skillArea
	Global.skillArea.visible = false
	Global.StopON = false
	
	$Up/MoneyMessage.visible = false
	$bossProtect.visible = false
	$Boss.visible = false
	$bossSkill.visible = false
	
	$backGround1.visible = false
	$backGround2.visible = false
	$Up/buttom1.visible = false
	$Up/buttom2.visible = false
	pass











