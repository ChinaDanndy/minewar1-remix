extends CanvasLayer

func updateText(soldier):
	$CardMessage/all/name.text = Global.STSData[soldier]["objectName"]
	
	if Global.STSData[soldier].has("cd"):
		$CardMessage/all/attribute/CD.visible = true
		$CardMessage/all/attribute/CD.text = ("冷却:%s"%Global.STSData[soldier]["cd"])
	else: $CardMessage/all/attribute/CD.visible = false
	
	if Global.STSData[soldier].has("damageBasic"): 
		$CardMessage/all/attribute/damage.visible = true
		if Global.STSData[soldier]["damageBasic"][1] == 0:
			$CardMessage/all/attribute/damage.text = (
				"伤害:%s"%Global.STSData[soldier]["damageBasic"][0])
		else: $CardMessage/all/attribute/damage.text = (
				"伤害:%s/%s"%[Global.STSData[soldier]["damageBasic"][0]
				,Global.STSData[soldier]["damageBasic"][1]])
	else: $CardMessage/all/attribute/damage.visible = false
	
	if Global.STSData[soldier].has("health"):
		$CardMessage/all/attribute/health.visible = true
		$CardMessage/all/attribute/health.text = ("生命:%s"%Global.STSData[soldier]["health"])
	else: $CardMessage/all/attribute/health.visible = false

	if Global.STSData[soldier].has("speedBasic"):
		$CardMessage/all/attribute/speed.visible = true
		$CardMessage/all/attribute/speed.text = ("速度:%s"%Global.STSData[soldier]["speedBasic"])
	else: $CardMessage/all/attribute/speed.visible = false

	if Global.STSData[soldier].has("attRangeBasic"):
		$CardMessage/all/attribute/range.visible = true
		if Global.STSData[soldier]["attRangeBasic"][1] == 0:
			$CardMessage/all/attribute/range.text = (
				"射程:%s"%Global.STSData[soldier]["attRangeBasic"][0])
		else:
			$CardMessage/all/attribute/range.text = (
				"射程:%s/%s"%[Global.STSData[soldier]["attRangeBasic"][0],
				Global.STSData[soldier]["attRangeBasic"][1]])
	else: $CardMessage/all/attribute/range.visible = false

	if Global.STSData[soldier].has("description"):
		$CardMessage/description.visible = true
		$CardMessage/description.text = Global.STSData[soldier]["description"]
	else: $CardMessage/description.visible = false

##	if Global.STSData[soldier].has("shield"):
##		$CardMessage/all/attribute/shield.text = ("护盾:%s"%Global.STSData[soldier]["shield"])
##	else: $CardMessage/all/attribute/shield.visible = false
#

	pass
