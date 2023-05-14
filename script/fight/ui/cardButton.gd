extends Control
enum  cType {BUY,CHOICE}
@export var cardType:int
@onready var cantBuy = $cantChoice
@onready var choice = $choice
var outLine = true



var soldier
var price
var areaId

var choiceArea = preload("res://sence/fight/ui/choiceArea.tscn")
var num
func _ready():
	material = null
	Global.FightSence.cardMessage.connect(cardMessageOut)
	Global.FightButton.FightStart.connect(buyCardReSet)
	num = int(str(name))-1
	pass
	
func display():
	price = Global.STSData[soldier]["price"]#基本属性填充
	$cardPrice.text = str(price)
	$cardName.text = soldier
	pass
	
func cardMessageOut():
	match cardType:
		cType.CHOICE:
			soldier = Global.LevelData[0]["allVillageObject"][num]#获得士兵数据
			if soldier != null:  display()
			var banCard = Global.LevelData[Global.Level].size()-2#查看是否为禁用卡
			if Global.LevelData[Global.Level][banCard].has(soldier):
				self.button_mask = 0
				outLine = false
				cantBuy.visible = true
		cType.BUY:
			self.button_mask = 0
			outLine = false
			if Global.ChoiceWindow.visible == false:#特定卡没有选卡
				var card = Global.LevelData[Global.Level].size()-1
				soldier = Global.LevelData[Global.Level][card][num]
				buyCardReSet()
				display()
	pass

func buyCardReSet():
	if cardType == cType.BUY:
		self.button_mask = MOUSE_BUTTON_MASK_LEFT
		outLine = true
	pass

func _process(_delta):
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:
				pass
			cType.BUY: 
				soldier = Global.ChosenCard[num]
				if soldier != null: 
					outLine = true
					self.button_mask = MOUSE_BUTTON_MASK_RIGHT
					display()
					if num != 0&&Global.ChosenCard[num-1] == null:#已选卡中中间卡被退回
						Global.ChosenCard[num-1] = Global.ChosenCard[num]
						Global.ChosenId[num-1] = Global.ChosenId[num]
						Global.ChosenCard[num] = null
						Global.ChosenId[num] = null
						$cardPrice.text = ""
						$cardName.text = ""
	pass

func _on_pressed():
	if Global.ChoiceWindow.visible == true:
		match cardType:
			cType.CHOICE:#选卡
				Global.ChosenCard[Global.ChosenCardNum] = soldier
				Global.ChosenId[Global.ChosenCardNum] = self
				Global.ChosenCardNum += 1
				cantBuy.visible = true
			cType.BUY:#退卡
				Global.ChosenId[num].button_mask = MOUSE_BUTTON_MASK_LEFT
				Global.ChosenId[num].cantBuy.visible = false
				Global.ChosenId[num].outLine = true
				Global.ChosenCard[num] = null
				Global.ChosenId[num] = null
				Global.ChosenCardNum -= 1
				$cardPrice.text = ""
				$cardName.text = ""
		self.button_mask = 0
		outLine = false
		material = null
	else:
		if cardType == cType.BUY:#战斗开始买卡
			if Global.CardBuy == null&&Global.NowMoney>=price:#士兵
				if Global.STSData[soldier]["type"] == "soldier":
					Global.NowMoney -= price
					var friend = Global.VillageSoldier.instantiate()
					Global.root.add_child(friend)
					friend.firstSetting(soldier)
			#塔和技能有区域选择
			if (Global.STSData[soldier]["type"] == "tower")||(Global.STSData[soldier]["type"] == "skill"):
				match self.button_mask:
					MOUSE_BUTTON_MASK_LEFT:#左键
						Global.CardBuy == soldier
						var Area = choiceArea.instantiate()
						Global.root.add_child(Area)
						#更新选择盒子尺寸
						if Global.STSData[soldier]["type"] == "tower":#选塔位置
							Area.colorBox.size = Global.STSData[soldier]["collBox"]
							Area.colorBox.position = Global.STSData[soldier]["collBox"]/-2
							Area.collLine.target_position = Vector2(Global.STSData[soldier]["collBox"].x*2,0)
							Area.collLine.position = Vector2(-((Global.STSData[soldier]["collBox"].x*2)-(Global.STSData[soldier]["collBox"].x/2)),0)
							Global.towerArea.visible = true
							Area.area = Global.towerArea
							Area.which = Global.Tower
						if Global.STSData[soldier]["type"] == "skill":#选技能位置
							Area.colorBox.size = Vector2(Global.STSData[soldier]["aoeRange"],Global.NormalAOERangeY)
							Area.colorBox.position = Vector2(Global.STSData[soldier]["aoeRange"]/-2,Global.NormalAOERangeY/-2)
							Area.collLine.enabled
							Global.skillArea.visible = true
							Area.area = Global.skillArea
							Area.which = Global.Skill
						#防止塔堆叠放置
						Area.position = Global.VillagePoint
						Area.soldier = soldier
						Area.card = self
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
	if outLine == true: material = Global.CardOutLine
	pass
	
func _on_mouse_exited():
	if outLine == true: material = null
	pass
