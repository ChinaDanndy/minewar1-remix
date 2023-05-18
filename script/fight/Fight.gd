extends Node2D
var count = 0
var summonEnemy = preload("res://script/fight/calu/summonEnemy.gd")
var summonEnemyID
const lvType = {}
var BossLv

var attackTime
var moneyTime
var thunderTime
var thunderTimeRand

signal cardMessage
signal reloadSence
signal fightCard

signal BossLv2
signal BossLv3



func _ready():
	Global.NowLevel = 1
	if Global.NowLevel != 1: $Boss.free()
	


	
	
	moneyTime = Global.LevelData[0]["moneySpeed"]
	Global.ThunderSpeed = Global.LevelData[0]["thunderSpeed"]
	thunderTime = Global.LevelData[Global.NowLevel][0]["thunderTime"]
	thunderTimeRand = Global.LevelData[Global.NowLevel][0]["thunderTimeRand"]
	
	Global.VillageBase.camp = Global.VILLAGE
	Global.VillageBase.firstSetting("a")#"baseVillageHealth"
	Global.MonsterBase.camp = Global.MONSTER
	Global.MonsterBase.firstSetting("b")#"baseMonsterHealth"
	
	if Global.LevelData[Global.NowLevel][-1].is_empty():
		Global.ChoiceWindow.visible = true
		
		var allMonster = []#怪物展示，自动填充目前所有有的怪物
		for i in Global.LevelData[Global.NowLevel][1].size():
			for j in Global.LevelData[Global.NowLevel][1][i]["soldier"]:
				if !allMonster.has(j): allMonster.append(j)	
		if !allMonster.is_empty():
			for i in allMonster.size():
				var mShow = get_node("monsterShow/HBoxContainer/mShow%s"%(i+1))
				mShow.texture = load("res://assets/objects/soldier/%s/walk/walk1.png"%allMonster[i])
		$monsterShow.visible = true
	else:
		Global.ChoiceWindow.visible =false#有给定卡不开选卡
		fightStart()

	#monseter 680
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
	
func fightStart():
	Global.CardUp = 6
	emit_signal("fightCard")
	$monsterShow.visible = false
	#await get_tree().create_timer(1,false).timeout#开局延迟开始
	$Moneytext.visible = true
	$baseMonster.visible = true
	if Global.NowLevel == 1:  
		$baseMonster.queue_free()
		Global.MonsterBase = $Boss
		BossLv = 1
	$baseVillage.visible = true
	$Spacetext.visible = false

	match Global.LevelData[Global.NowLevel][0]["levelType"]:
		"attack":
			$baseVillage/Label.visible = false 
			attackTime = Global.LevelData[Global.NowLevel][0]["attackTime"]
			$AttackTime.visible = true
			$attackTimer.start(1)
		"defence": $baseMonster/Label.visible = false 
		
	var newEnemy = summonEnemy.new()
	Global.add_child(newEnemy)
	summonEnemyID = newEnemy
	
	$Moneytimer.start(moneyTime)
	if thunderTime >0: 
		$Thundertimer.start(thunderTime+randi_range(-thunderTimeRand,thunderTimeRand))

	pass
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_select"):
		Global.MonsterBase.health = 0
		pass

		
#	if Global.MonsterDeaths >= 1:#怪物死一定数量生成蜘蛛笼
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
	
#	match Global.LevelData[Global.NowLevel][0]["levelType"]:
#		"attack":
#			if attackTime <=0:#loss
#				if Global.MonsterBase.health > 0||Global.VillageBase.health <= 0: 
#					Global.StopWindow.text("lose")
#			else: if Global.MonsterBase.health <= 0: Global.StopWindow.text("win")
#		"normal":

#		"defence":
#			if Global.VillageBase.health <= 0: Global.StopWindow.text("lose")
#			if Global.LevelOver == true&&get_tree().get_nodes_in_group("monsterSoldier").is_empty():
#				Global.StopWindow.text("win")
	
	
	
	if Global.MonsterBase.health<=45&&Global.NowLevel == 2:
		Global.NowLevel += 1
		summonEnemyID.queue_free()
		var newEnemy = summonEnemy.new()
		Global.add_child(newEnemy)
		summonEnemyID = newEnemy
		attackTime = Global.LevelData[Global.NowLevel][0]["attackTime"]
		emit_signal("BossLv3")
	
	if Global.VillageBase.health <= 0: Global.StopWindow.text("lose")
	if Global.MonsterBase.health <= 0: Global.StopWindow.text("win")
	
	if Global.LevelData[Global.NowLevel][0]["levelType"] == "attack":
		#if BossLv == null||BossLv == 3: 
		if attackTime <= 0: Global.VillageBase.health = 0
	if Global.LevelData[Global.NowLevel][0]["levelType"] == "defence":
		if Global.LevelOver == true&&get_tree().get_nodes_in_group("monsterSoldier").is_empty(): 
			if Global.NowLevel !=  1: 
				Global.MonsterBase.health = 0
			else:
				Global.NowLevel += 1
				summonEnemyID.queue_free()
				var newEnemy = summonEnemy.new()
				Global.add_child(newEnemy)
				summonEnemyID = newEnemy
				emit_signal("BossLv2")


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
	if summonEnemyID != null: summonEnemyID.free()
	Global.NowMoney = 0
	Global.MonsterDeaths = 0
	Global.CardBuy = null
	Global.Contrl = null
	Global.LevelOver = false
	Global.ChosenCard = [null,null,null,null,null,null]
	Global.ChosenId = [null,null,null,null,null,null]
	Global.ChosenCardNum = 0
	emit_signal("reloadSence")
	pass
	
func _on_tree_entered():
	Global.FightSence = self
	Global.ChoiceWindow = $choiceCard
	Global.FightButton = $choiceCard/fightButton
	Global.FightButton.fight.connect(fightStart)
	if Global.CardUp == 4:
		$card/HBoxContainer/CardButton5.visible = false
		$card/HBoxContainer/CardButton6.visible = false
	if Global.CardUp == 5: $card/HBoxContainer/CardButton6.visible = false
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
	
	$Moneytext.visible = false
	$Spacetext.visible = false
	$AttackTime.visible = false
	$baseMonster.visible = false
	$baseVillage.visible = false

	pass








