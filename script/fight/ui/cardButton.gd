extends Control
enum  cType {BUY,CHOICE,SHOP,SHOW}
const HAS = 4
const NOHAS = 3
var update = false

@export var cardType:int
@onready var cantBuy = $cantChoice
@onready var explainBox = $ExplainBox
var explainText
var explainName
var outLine = true

var soldier
var price
var areaId
var choiceArea = preload("res://sence/fight/ui/choiceArea.tscn")
var num
var cardNum
signal reSet

func _ready():
	cantBuy.visible = false
	#$ExplainBox.visible = false
	num = int(str(name))-1
	match cardType:
		cType.CHOICE:
			soldier = Global.LevelData[0]["allVillageObject"][num]#获得士兵数据
			if soldier != null:  display()
			if Global.LevelData[0]["villObjectHasLevel"][soldier] > Global.Level:
				visible = false
			if (Global.LevelData[Global.NowLevel]["banCard"].has(soldier))||(#查看是否为禁用卡BAN
				Global.LevelData[0]["allVillageBuyObject"].has(soldier)&&(#外面没购买的卡也不能选
					Global.Brought[soldier]==NOHAS))||(soldier == null):
				self.button_mask = 0
				#outLine = false
				cantBuy.visible = true
				if soldier == null: cantBuy.visible = true
		cType.BUY:
			Global.FightSence.fightCard.connect(cardReSet)#特定卡获得数据
			Global.FightButton.fight.connect(cardReSet)#选卡开始游戏后重置鼠标碰撞层
			self.button_mask = 0
			#outLine = false
		cType.SHOP:
			if get_parent().name == "Update":
				soldier = Global.LevelData[0]["Update"][num]#升级价格和出现关卡第二个要出现两次
				update = true
			else: soldier = Global.LevelData[0]["allVillageBuyObject"][num]
			display()
			if  Global.Point < price||Global.Brought[soldier] == HAS||Global.Brought[soldier] == 2:
				self.button_mask = 0
				#outLine = false
			if Global.Brought[soldier] == HAS||Global.Brought[soldier] == 2: 
				cantBuy.visible = true
		cType.SHOW: 
			display()
			Global.ChangePageButton.reSetAll.connect(cardReSet)
			


	
#	if Global.TextData.has(soldier)&&cardType == cType.SHOP:
#		$ExplainBox/Pos/name.text = Global.TextData[soldier]["name"]
#		$ExplainBox/Pos/explain.text = Global.TextData[soldier]["explain"]
#		#explainBox.visible = true
#		pass
	pass
	
func display():
	visible = true
	match cardType:
		cType.CHOICE,cType.BUY:
			price = Global.STSData[soldier]["price"]#基本属性填充
		cType.SHOP: 
			if update == true: price = Global.LevelData[0]["UpdatePrice"][num][Global.Brought[soldier]]
			else: price = Global.LevelData[0]["villageBuyPrice"][num]
		cType.SHOW: 
			soldier = Global.LevelData[0][Global.Page[Global.PageNow]][num]
			if Global.PageNow == true:
				if Global.LevelData[0]["allVillageBuyObject"].has(soldier):#需购买卡没买不显示
					if Global.Brought[soldier] == NOHAS: visible = false
				else:
					if Global.LevelData[0]["villObjectHasLevel"][soldier] > Global.Level: 
						visible = false
			else: if !Global.NowMonsterObject.has(soldier): visible = false
			if soldier == null: visible = false
			
	$cardName.text = soldier
	if cardType != cType.SHOW: $cardPrice.text = str(price)
	pass
	
func cardReSet():
	if Global.ChoiceWindow.visible == false&&cardType == cType.BUY:#特定卡没有选卡
		soldier = Global.LevelData[Global.NowLevel]["chosenCard"][num]
		if soldier != null: display()
		else: visible = false
	self.button_mask = MOUSE_BUTTON_MASK_LEFT
	#outLine = true
	cantBuy.visible = false
	if cardType == cType.SHOW||cardType == cType.SHOP: display()
	pass

func _process(_delta):
	$ExplainBox/Pos.position = global_position
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:
				if cantBuy.visible == false:
					if Global.ChosenCard[Global.CardUp-1] == null:
						#outLine = true
						self.button_mask = MOUSE_BUTTON_MASK_LEFT
					else:
						#outLine = false
						material = null
						self.button_mask = 0
					pass
			cType.BUY: 
				soldier = Global.ChosenCard[num]
				if soldier != null: 
					#outLine = true
					self.button_mask = MOUSE_BUTTON_MASK_RIGHT
					display()
					if num != 0&&Global.ChosenCard[num-1] == null:#已选卡中中间卡被退回
						Global.ChosenCard[num-1] = Global.ChosenCard[num]
						Global.ChosenId[num-1] = Global.ChosenId[num]
						Global.ChosenCard[num] = null
						Global.ChosenId[num] = null
						$cardPrice.text = ""
						$cardName.text = ""
				else:
					#outLine = false
					material = null
					self.button_mask = 0
			cType.SHOP: 
				if update == true: 
					if Global.LevelData[0]["UpdateLevel"][num][Global.Brought[soldier]] > Global.Level:
						visible = false#升级后两个价格数据一样
				else:  if Global.LevelData[0]["villageBuyLevel"][num] > Global.Level: visible = false
				
	pass

func _on_pressed():
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:#选卡
				Global.ChosenCard[Global.ChosenCardNum] = soldier
				Global.ChosenId[Global.ChosenCardNum] = self
				Global.ChosenCardNum += 1
			cType.BUY:#退卡
				Global.ChosenId[num].button_mask = MOUSE_BUTTON_MASK_LEFT
				Global.ChosenId[num].cantBuy.visible = false
				#Global.ChosenId[num].outLine = true
				Global.ChosenCard[num] = null
				Global.ChosenId[num] = null
				Global.ChosenCardNum -= 1
				$cardPrice.text = ""
				$cardName.text = ""
			cType.SHOP:#买卡
				#if  Global.Point >= price&&Global.CardBrought[soldier] == false:
				if update == true:
					Global.Brought[soldier] += 1
				else:
					Global.Brought[soldier] = HAS
				Global.Point -= price
			cType.SHOW:#展示图鉴
				if Global.ShowLastId != null:
					Global.ShowLastId.button_mask = MOUSE_BUTTON_MASK_LEFT
					#Global.ShowLastId.outLine = true
					Global.ShowLastId.cantBuy.visible = false
				Global.ShowName.text = soldier
				Global.ShowLastId = self

		if cardType != cType.BUY: cantBuy.visible = true
		self.button_mask = 0
		#outLine = false
		material = null
		$ExplainBox.visible = false
		if cardType == cType.SHOP&&update == true&&Global.Brought[soldier] == 1: 
			cardReSet()
	else:
		if cardType == cType.BUY:#战斗开始买卡
			if Global.CardBuy == null&&Global.NowMoney>=price:#士兵
				if Global.STSData[soldier]["type"] == "soldier":
					Global.NowMoney -= price
					var friend = Global.Soldier.instantiate()
					friend.camp = Global.VILLAGE
					Global.root.add_child(friend)
					friend.firstSetting(soldier)
				#塔和技能有区域选择
				if (Global.STSData[soldier]["type"] == "tower")||(Global.STSData[soldier]["type"] == "skill"):
					match self.button_mask:
						MOUSE_BUTTON_MASK_LEFT:#左键
							Global.CardBuy = soldier
							var Area = choiceArea.instantiate()
							Area.soldier = soldier
							Area.card = self
							Global.root.add_child(Area)
							areaId = Area#传递创建的选择区域id
							self.button_mask = MOUSE_BUTTON_MASK_RIGHT
						MOUSE_BUTTON_MASK_RIGHT:#右键
							Global.CardBuy = null
							areaId.queue_free()
							Global.towerArea.visible = false
							Global.skillArea.visible = false
							self.button_mask = MOUSE_BUTTON_MASK_LEFT
	pass

func _on_mouse_entered():
	#if outLine == true: material = Global.CardOutLine
	#await get_tree().create_timer(0.5,false).timeout
#	if $ExplainBox/Pos/explain.text != "explain": $ExplainBox.visible = true
	pass
	
func _on_mouse_exited():
	#if outLine == true: material = null
#	$ExplainBox.visible = false
	pass
