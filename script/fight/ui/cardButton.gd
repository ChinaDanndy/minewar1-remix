extends Control

var soldier
var price
var areaId
var coiceArea = preload("res://sence/fight/ui/choiceArea.tscn")
func _ready():
	Global.FightSence.cardMessage.connect(cardMessageOut)
	pass
	
func cardMessageOut():
	soldier = Global.LevelData[Global.Level][-1][int(str(name))-1]#获得士兵数据
	if soldier == null: 
		self.visible = false
	else:
		price = Global.STSData[soldier]["price"]#基本属性填充
		$cardPrice.text = str(price)
		$cardName.text = soldier
	pass

func _on_pressed():
	if Global.CardBuy == null&&Global.NowMoney>=price:
		if Global.STSData[soldier]["type"] == Global.Type.SOLDIER:
			Global.NowMoney -= price
			var friend = Global.VillageSoldier.instantiate()
			Global.root.add_child(friend)
			friend.firstSetting(soldier)
		if soldier == "power":
			Global.villFirEffTime = Global.STSData[soldier]["time"]
			Global.NowMoney -= price
			pass
			
			
		if (Global.STSData[soldier]["type"] == Global.Type.TOWER)||(Global.STSData[soldier]["type"] == Global.Type.SKILL&&soldier != "power"):
			match self.button_mask:
				1:#左键
					Global.CardBuy == soldier
					var Area = coiceArea.instantiate()
					Global.root.add_child(Area)
					#更新选择盒子尺寸
					match Global.STSData[soldier]["type"]:
						Global.Type.TOWER:#选塔位置
							Area.colorBox.size = Global.STSData[soldier]["collBox"]
							Area.colorBox.position = Global.STSData[soldier]["collBox"]/-2
							Area.collLine.target_position = Vector2(Global.STSData[soldier]["collBox"].x*2,0)
							Area.collLine.position = Vector2(-((Global.STSData[soldier]["collBox"].x*2)-(Global.STSData[soldier]["collBox"].x/2)),0)
							Global.towerArea.visible = true
							Area.area = Global.towerArea
							Area.which = Global.Tower
						Global.Type.SKILL:#选技能位置
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
					self.button_mask = 2
				2:#右键
					Global.CardBuy = null
					areaId.queue_free()
					Global.towerArea.visible = false
					Global.skillArea.visible = false
					self.button_mask = 1
	pass

func _on_mouse_entered():
	material = Global.OutLine
	pass
	
func _on_mouse_exited():
	material = null
	pass
