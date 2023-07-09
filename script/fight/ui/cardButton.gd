extends Control
enum  cType {USE,CHOICE,CARDSHOW,BUYSHOW,SHOP}
const HAS = 4
const NOHAS = 3
var update = false

@export var cardType:int
@export var num:int
var showNum:int

@onready var cantBuy = $cantChoice
#@onready var explainBox = $ExplainBox
var explainText
var explainName
#var outLine = true
var cardText = true
var cd
var cdAll
var cdStart = false
var originSize

var soldier
var price = 0
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
		cType.CHOICE:#等待被选卡
			soldier = Global.LevelData[0]["allVillageObject"][num]#获得士兵数据
			showNum = num
			if Global.LevelData[0]["cardShow"].has(soldier):
				if Global.Level-1 <= Global.LevelData[0]["cardShow"].find(soldier):
					soldier = null
					visible = false
			if Global.LevelData[0]["buyShow"].has(soldier):
				if Global.Brought[soldier] == false:
					soldier = null
					visible = false
		cType.USE:#显示选卡
			Global.FightSence.fightCard.connect(cardReSet)#特定卡获得数据
			Global.FightButton.fight.connect(buyCardReSet)#选卡开始游戏后重置鼠标碰撞层
			if num > Global.CardUp-1: visible = false#控制选卡位
		cType.CARDSHOW:#新卡
			self.button_mask = 0
			if Global.NowLevel == Global.Level:
				if Global.Level<8:
					soldier = Global.LevelData[0]["cardShow"][Global.NowLevel-1]
		cType.BUYSHOW:#新可购买卡
			self.button_mask = 0
			if Global.NowLevel == Global.Level:
				if Global.Level<7:
					soldier = Global.LevelData[0]["buyShow"][Global.NowLevel-1]
		cType.SHOP:#买卡
			soldier = Global.LevelData[0]["shop"][num]
			if (Global.Brought[soldier] == true): cantBuy.visible = true#已买不再显示
			if Global.Level-1 <= Global.LevelData[0]["buyShow"].find(soldier):
				soldier = null#还没解锁不显示
				visible = false
				
	match cardType:
		cType.CARDSHOW,cType.BUYSHOW,cType.SHOP:#补充icon
			showNum = Global.LevelData[0]["allVillageObject"].find(soldier)
	if soldier != null&&cardType != cType.USE:  display()#填充数据
	pass
	
func display():
	visible = true
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
	$icon.texture = load("res://assets/UI/cardIcon/cardIcon%s.png"%(showNum+1))
	pass
	
func cardReSet():
	if Global.ChoiceWindow.visible == false&&cardType == cType.USE:#特定卡获取数据
		soldier = Global.LevelData[Global.NowLevel]["chosenCard"][num]
		showNum = Global.LevelData[0]["allVillageObject"].find(soldier)
		if soldier != null: 
			display()
			buyCardReSet()
		else: visible = false
	pass

func buyCardReSet():#开始游戏前卡片初始化
	cardText = false
	Global.CardTextWindow.visible = false
	cantBuy.visible = true
	self.button_mask = MOUSE_BUTTON_MASK_LEFT
	$CD.visible = true
	if cd != null: $CDTimer.start(cd)
	pass

func useCardClear():#退卡请数据
	Global.ChosenCard[num] = null
	Global.ChosenId[num] = null
	$cardPrice.text = ""
	$icon.texture = null
	pass

func _process(_delta):
	#$ExplainBox/Pos.position = global_position
	$click.volume_db = Global.SeDB
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:
				if Global.ChosenCard[Global.CardUp-1] == null:#选卡满了不能再选
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
				if soldier == null&&self.button_mask !=0:  
					cardText = false
					self.button_mask = 0
			cType.SHOP: if Global.Point < price: self.button_mask = 0
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
	$click.play()
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:#选卡
				Global.ChosenCard[Global.ChosenCardNum] = soldier
				Global.ChosenId[Global.ChosenCardNum] = self
				Global.ChosenCardNum += 1
				cantBuy.visible = true
				#if Global.ChosenCard[-1] != null: Global.FightButton.visible = true
			cType.USE:#退卡
				Global.ChosenId[num].button_mask = MOUSE_BUTTON_MASK_LEFT
				Global.ChosenId[num].cantBuy.visible = false
				Global.ChosenCardNum -= 1
				useCardClear()
			cType.SHOP:#买卡
				cantBuy.visible = true
				Global.Point -= price
				Global.Brought[soldier] = true
				pass
		Global.CardTextWindow.visible = false
	else:
		if cardType == cType.USE:#战斗开始买卡
			if Global.STSData[soldier]["type"] == "soldier"&&Global.CardBuy == null:
				Global.NowMoney -= price
				var friend = Global.Soldier.instantiate()
				friend.camp = Global.VILLAGE
				Global.root.add_child(friend)
				friend.firstSetting(soldier)
				buyCardReSet()
			#塔和技能有区域选择
			if (Global.STSData[soldier]["type"] == "tower")||(
				Global.STSData[soldier]["type"] == "skill"):
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
							material = Global.SoldierOutLine
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
	pass
	
func _on_mouse_exited():
	Global.CardTextWindow.visible = false
	pass





