extends Control
enum  cType {USE,CHOICE,CARDSHOW,BUYSHOW,SHOP}
const HAS = 4
const NOHAS = 3
var update = false

@export var cardType:int
@export var num:int
var showNum:int

@onready var cantBuy = $cantChoice
@onready var explainBox = $ExplainBox
var explainText
var explainName
#var outLine = true
var cardText = true
var cd
var cdAll
var cdStart = false
var originSize

var soldier
var price = ""
var areaId
var choiceArea = preload("res://sence/fight/ui/choiceArea.tscn")

#var cardNum
#signal reSet

func _ready():
	originSize = size.y
	cantBuy.visible = false
	$CD.visible = false
	$icon.texture = null
	$cardPrice.text = ""
	
	num = int(str(name))-1
	match cardType:
		cType.CHOICE:
			soldier = Global.LevelData[0]["allVillageObject"][num]#获得士兵数据
			showNum = num
			if soldier != null:  display()
#			if Global.LevelData[0]["villObjectHasLevel"][soldier] > Global.Level:
#				visible = false
#			if (Global.LevelData[Global.NowLevel]["banCard"].has(soldier))||(#查看是否为禁用卡BAN
##				Global.LevelData[0]["allVillageBuyObject"].has(soldier)&&(#外面没购买的卡也不能选
##					Global.Brought[soldier]==NOHAS))||(soldier == null):
##				self.button_mask = 0
##				#outLine = false
##				cantBuy.visible = true
#				if soldier == null: cantBuy.visible = true
		cType.USE:
			Global.FightSence.fightCard.connect(cardReSet)#特定卡获得数据
			Global.FightButton.fight.connect(buyCardReSet)#选卡开始游戏后重置鼠标碰撞层
		cType.CARDSHOW:
			self.button_mask = 0
			soldier = Global.LevelData[0]["cardShow"][Global.NowLevel-1]
			showNum = Global.LevelData[0]["allVillageObject"].find(soldier)
			if soldier != null:  display()
		cType.BUYSHOW:
			self.button_mask = 0
			soldier = Global.LevelData[0]["buyShow"][Global.NowLevel-1]
			showNum = Global.LevelData[0]["allVillageObject"].find(soldier)
			if soldier != null:  display()
		cType.SHOP:
			soldier = Global.LevelData[0]["shop"][num]
			showNum = Global.LevelData[0]["allVillageObject"].find(soldier)
			if soldier != null:  display()

			#Global.FightSence.cardCD.connect(cardCDStart)
			#self.button_mask = 0
#		cType.SHOP:
#			if get_parent().name == "Update":
#				soldier = Global.LevelData[0]["Update"][num]#升级价格和出现关卡第二个要出现两次
#				update = true
#			else: soldier = Global.LevelData[0]["allVillageBuyObject"][num]
#			display()
#			if  Global.Point < price||Global.Brought[soldier] == HAS||Global.Brought[soldier] == 2:
#				self.button_mask = 0
#				#outLine = false
#			if Global.Brought[soldier] == HAS||Global.Brought[soldier] == 2: 
#				cantBuy.visible = true
#		cType.SHOW: 
#			display()
#			Global.ChangePageButton.reSetAll.connect(cardReSet)
#	if Global.TextData.has(soldier)&&cardType == cType.SHOP:
#		$ExplainBox/Pos/name.text = Global.TextData[soldier]["name"]
#		$ExplainBox/Pos/explain.text = Global.TextData[soldier]["explain"]
#		#explainBox.visible = true
#		pass
	
	pass
	
func display():
	visible = true
#	match cardType:
#		cType.CHOICE,cType.USE:
#基本属性填充
	match cardType:
		cType.CHOICE,cType.USE,cType.CARDSHOW:
			cd = Global.STSData[soldier]["cd"]
			cdAll = cd
			price = Global.STSData[soldier]["price"]


	if cardType == cType.BUYSHOW:
		if Global.LevelData[0]["buyPrice"].has(soldier):
			price = Global.LevelData[0]["buyPrice"][soldier]
		else: self.texture_normal = null
	if cardType == cType.SHOP: price = Global.LevelData[0]["buyPrice"][soldier]

	
	$cardPrice.text = str(price)
	#if Global.STSData[soldier].has("price"):
		
	#if Global.STSData[soldier].has("cd"):

#		cType.SHOP: 
#			if update == true: price = Global.LevelData[0]["UpdatePrice"][num][Global.Brought[soldier]]
#			else: price = Global.LevelData[0]["villageBuyPrice"][num]
#		cType.SHOW: 
#			soldier = Global.LevelData[0][Global.Page[Global.PageNow]][num]
#			if Global.PageNow == true:
#				if Global.LevelData[0]["allVillageBuyObject"].has(soldier):#需购买卡没买不显示
#					if Global.Brought[soldier] == NOHAS: visible = false
#				else:
#					if Global.LevelData[0]["villObjectHasLevel"][soldier] > Global.Level: 
#						visible = false
#			else: if !Global.NowMonsterObject.has(soldier): visible = false
#			if soldier == null: visible = false
	$icon.texture = load("res://assets/UI/cardIcon/cardIcon%s.png"%(showNum+1))
	
	pass
	
func cardReSet():
	if Global.ChoiceWindow.visible == false&&cardType == cType.USE:#特定卡没有选卡
		soldier = Global.LevelData[Global.NowLevel]["chosenCard"][num]
		showNum = Global.LevelData[0]["allVillageObject"].find(soldier)
		if soldier != null: 
			display()
			buyCardReSet()
		else: visible = false
		
#	if cardType == cType.SHOW||cardType == cType.SHOP: 
#		self.button_mask = MOUSE_BUTTON_MASK_LEFT
#		#outLine = true
#		cantBuy.visible = false
#		display()
#func cardCDStart(): 
#	if soldier != null:
#		$CDTimer.start(cd)
#		cdStart = true
#	pass
	pass

func buyCardReSet():
	cardText = false
	Global.CardTextWindow.visible = false#等待冷却
	cantBuy.visible = true
	self.button_mask = MOUSE_BUTTON_MASK_LEFT
	$CD.visible = true
	$CDTimer.start(cd)
	#if cdStart == true: 
	pass

func useCardClear():
	Global.ChosenCard[num] = null
	Global.ChosenId[num] = null
	$cardPrice.text = ""
	$icon.texture = null
	pass

func _process(_delta):
	$ExplainBox/Pos.position = global_position
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:
				if Global.ChosenCard[-1] == null: 
					self.button_mask = MOUSE_BUTTON_MASK_LEFT
				else: self.button_mask = 0
			cType.USE: 
				soldier = Global.ChosenCard[num]
				if soldier != null: 
					cardText = true
					showNum = Global.ChosenId[num].showNum
					self.button_mask = MOUSE_BUTTON_MASK_RIGHT
					display()
					if num != 0&&Global.ChosenCard[num-1] == null:#已选卡中中间卡被退回
						Global.ChosenCard[num-1] = Global.ChosenCard[num]
						Global.ChosenId[num-1] = Global.ChosenId[num]
						useCardClear()
				else: 
					cardText = false
					self.button_mask = 0
#				else:
#					#outLine = false
#					material = null
#					self.button_mask = 0
#			cType.SHOP: 
#				if update == true: 
#					if Global.LevelData[0]["UpdateLevel"][num][Global.Brought[soldier]] > Global.Level:
#						visible = false#升级后两个价格数据一样
#				else:  
#					if Global.LevelData[0]["villageBuyLevel"][num] > Global.Level: visible = false
	else:
		if cardType == cType.USE&&soldier != null:
			if Global.NowMoney >= price&&$CDTimer.time_left == 0&&cantBuy.visible == true:
				cantBuy.visible = false
				$CD.visible = false
				$CD.size.y = originSize
			if $CDTimer.time_left > 0:
				$CD.size.y = (originSize*($CDTimer.time_left/cd)) 
			if Global.NowMoney < price&&cantBuy.visible == false:
				cantBuy.visible = true
	pass

func _on_pressed():
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:#选卡
				Global.ChosenCard[Global.ChosenCardNum] = soldier
				Global.ChosenId[Global.ChosenCardNum] = self
				Global.ChosenCardNum += 1
				cantBuy.visible = true
			cType.USE:#退卡
				Global.ChosenId[num].button_mask = MOUSE_BUTTON_MASK_LEFT
				Global.ChosenId[num].cantBuy.visible = false
				Global.ChosenCardNum -= 1
				useCardClear()
		Global.CardTextWindow.visible = false
				#Global.ChosenId[num].outLine = true
		#self.button_mask = 0
#			cType.SHOP:#买卡
#				#if  Global.Point >= price&&Global.CardBrought[soldier] == false:
#				if update == true:
#					Global.Brought[soldier] += 1
#				else:
#					Global.Brought[soldier] = HAS
#				Global.Point -= price
#			cType.SHOW:#展示图鉴
#				if Global.ShowLastId != null:
#					Global.ShowLastId.button_mask = MOUSE_BUTTON_MASK_LEFT
#					#Global.ShowLastId.outLine = true
#					Global.ShowLastId.cantBuy.visible = false
#				Global.ShowName.text = soldier
#				Global.ShowLastId = self
#		if cardType != cType.USE: 
		#outLine = false
		#material = null
		#$ExplainBox.visible = false
#		if cardType == cType.SHOP&&update == true&&Global.Brought[soldier] == 1: 
#			cardReSet()
	else:
		if cardType == cType.USE:#战斗开始买卡
			if Global.NowMoney>=price&&$CDTimer.time_left == 0:#士兵
				if Global.STSData[soldier]["type"] == "soldier"&&Global.CardBuy == null:
					Global.NowMoney -= price
					var friend = Global.Soldier.instantiate()
					friend.camp = Global.VILLAGE
					Global.root.add_child(friend)
					friend.firstSetting(soldier)
					buyCardReSet()
				#塔和技能有区域选择
				if (Global.STSData[soldier]["type"] == "tower")||(Global.STSData[soldier]["type"] == "skill"):
					if (self.button_mask == MOUSE_BUTTON_MASK_LEFT&&Global.CardBuy == null)||(
					self.button_mask == MOUSE_BUTTON_MASK_RIGHT&&Global.CardBuy == soldier):
						match self.button_mask:
							MOUSE_BUTTON_MASK_LEFT:#左键
								Global.CardBuy = soldier
								var Area = choiceArea.instantiate()
								Area.soldier = soldier
								Area.card = self
								Global.root.add_child(Area)
								areaId = Area#传递创建的选择区域id
								self.button_mask = MOUSE_BUTTON_MASK_RIGHT
								material = Global.CardOutLine
							MOUSE_BUTTON_MASK_RIGHT:#右键
								Global.CardBuy = null
								areaId.queue_free()
								Global.towerArea.visible = false
								Global.skillArea.visible = false
								self.button_mask = MOUSE_BUTTON_MASK_LEFT
								material = null
	pass

func _on_mouse_entered():
	if cardText == true: 
		Global.CardTextWindow.updateText(soldier)
		Global.CardTextWindow.visible = true
	#if outLine == true: material = Global.CardOutLine
	#await get_tree().create_timer(0.5,false).timeout
#	if $ExplainBox/Pos/explain.text != "explain": $ExplainBox.visible = true
	pass
	
func _on_mouse_exited():
	if cardText == true: Global.CardTextWindow.visible = false
	#if outLine == true: material = null
#	$ExplainBox.visible = false
	pass





