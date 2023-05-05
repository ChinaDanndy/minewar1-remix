extends Control

var soldier
var price
var areaId

func _ready():
	Global.FightSence.cardMessage.connect(cardMessageOut)
	pass
	
func cardMessageOut():
	soldier = Global.LevelData[Global.Level][-1][int(str(name))-1]
	if soldier == null: 
		self.visible = false
	else:
		price = Global.STSData[soldier]["price"]
		$CardPrice.text = str(price)
		$CardName.text = soldier
	pass

func _on_pressed():
	if Global.CardBuy == null&&Global.NowMoney>=price:
		if Global.STSData[soldier]["type"] == Global.Type.PEOPLE:
			Global.NowMoney -= price
			var friend = Global.VillageSoldier.instantiate()
			Global.root.add_child(friend)
			friend.firstSetting(soldier)
			friend.position = Global.VillagePoint.position#100
		if Global.STSData[soldier]["type"] == Global.Type.TOWER||Global.STSData[soldier]["type"] == Global.Type.SKILL:
			match self.button_mask:
				1:#左键
					Global.CardBuy == soldier
					var Area = Global.ChoiceArea.instantiate()
					Global.root.add_child(Area)
					Area.position = Global.VillagePoint.position
					Area.soldier = soldier
					#更新选择盒子尺寸
					match Global.STSData[soldier]["type"]:
						Global.Type.TOWER:
							Area.colorBox.size = Global.STSData[soldier]["collBox"]
							Area.colorBox.position = Global.STSData[soldier]["collBox"]/-2
							Area.collLine.target_position = Vector2(Global.STSData[soldier]["collBox"].x*2,0)
							Area.collLine.position = Vector2(-((Global.STSData[soldier]["collBox"].x*2)-(Global.STSData[soldier]["collBox"].x/2)),0)
							Global.towerArea.visible = true
							Area.area = Global.towerArea
						Global.Type.SKILL:
							Area.colorBox.size = Vector2(Global.STSData[soldier]["aoeRange"][0],Global.NormalAOERangeY)
							Area.colorBox.position = Vector2(Global.STSData[soldier]["aoeRange"][0]/-2,Global.NormalAOERangeY/-2)
							Area.collLine.enabled = false
							Global.skillArea.visible = true
							Area.area = Global.skillArea
					#放置塔堆叠放置
					Area.card = self
					areaId = Area#传递创建的选择区域id
					self.button_mask = 2
				2:#右键
					Global.CardBuy = null
					areaId.queue_free()
					Global.towerArea.visible = false
					Global.skillArea.visible = false
					self.button_mask = 1
			

	pass # Replace with function body.
