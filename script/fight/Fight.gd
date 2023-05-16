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
signal fight
func _ready():
	Global.Level = 1
	
	moneyTime = Global.LevelData[0]["moneySpeed"]
	Global.ThunderSpeed = Global.LevelData[0]["thunderSpeed"]
	thunderTime = Global.LevelData[Global.Level][0]["thunderTime"]
	thunderTimeRand = Global.LevelData[Global.Level][0]["thunderTimeRand"]
	
	var mPicShow = Global.LevelData[Global.Level].size()-3
	if !Global.LevelData[Global.Level][mPicShow].is_empty():
		for i in Global.LevelData[Global.Level][mPicShow].size():
			var mShow = get_node("monsterShow/HBoxContainer/mShow%s"%(i+1))
			mShow.texture = load("res://assets/objects/soldier/%s/attack/attack1.png"%Global.LevelData[Global.Level][mPicShow][i])
		pass
	
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
	
	if !Global.LevelData[Global.Level][-1].is_empty():#有给定卡不开选卡
		Global.ChoiceWindow.visible =false
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
	var mPicShow = Global.LevelData[Global.Level].size()-3
	for i in Global.LevelData[Global.Level][mPicShow].size():
		var mShow = get_node("monsterShow/HBoxContainer/mShow%s"%(i+1))
		mShow.texture = null
	#await get_tree().create_timer(1,false).timeout#开局延迟开始
	var newEnemy = summonEnemy.new()
	
	Global.root.call_deferred("add_child",newEnemy)
	newEnemy.call_deferred("firstStart")
	newEnemy.name = "summonEnemy"
	summonEnemyID = newEnemy
	emit_signal("fight")
	$Moneytimer.start(moneyTime)
	if thunderTime >0: $Thundertimer.start(thunderTime+randi_range(-thunderTimeRand,thunderTimeRand))

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
	if summonEnemyID != null: summonEnemyID.queue_free()
	Global.NowMoney = 0
	Global.MonsterDeaths = 0
	Global.CardBuy = null
	Global.Contrl = null
	Global.ChosenCard = [null,null,null,null]
	Global.ChosenId = [null,null,null,null,null]
	Global.ChosenCardNum = 0
	emit_signal("reloadSence")
	pass
	
func _on_tree_entered():
	Global.ChoiceWindow = $choiceCard
	Global.FightButton = $choiceCard/fightButton
	Global.FightButton.fight.connect(fightStart)
	#Global.StopWindowLayer = $StopWindowLayer
	
	Global.FightSence = self
	Global.FightGroundY = $ground.position.y
	Global.FightSkyY = $sky.position.y
	Global.VillagePoint = $VillagePoint.position
	Global.MonsterPoint = $MonsterPoint.position#740
	
	Global.VillageBase = $baseVillage/collBox
	Global.MonsterBase = $baseMonster/collBox
	
	Global.towerArea = $towerArea
	Global.towerArea.visible = false
	Global.skillArea = $skillArea
	Global.skillArea.visible = false
	Global.StopON = false
	pass








