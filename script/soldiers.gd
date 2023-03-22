extends CharacterBody2D
var camp#
var kind#
var collKind#
var health#
var soldiername

var type = Global.Type.PEOPLE
var other

enum Ani {WALK,ATTACK1,ATTACK2,ATTACK3,STOP,DEATH,AWALK,AATTACK1}
enum State {ATTACK,STOP,DEATH,BACK,PUSH,OUTSEA,INSEA}
var picture = load("res://assets/soldiers/steve.png")  #死亡时picture要free
var totalPictureNumber = 11#
var animationStart = [0,6,0,0,9,10,0,0]#
var animationEnd = [5,10,0,0,9,10,0,0]#
var seaAniNumber#
var currentState = State.PUSH
var currentAni = Ani.WALK
var walkAni = Ani.WALK
var attack1Ani = Ani.ATTACK1
var standardState = State.PUSH
var standardAni = walkAni
var seaAni = 0
var currentAnimationStart = animationStart[currentAni]
var currentAnimationEnd = animationEnd[currentAni]

var aniTimeBasic = 0.2#标准图片切换间隔
var aniTime = aniTimeBasic
var aniTimeCut = 0
var aniTimeEffect = 0

var speedBasic = 0.6#
var speed = Vector2(0,0)
var speedAdd = 0
var speedEffect = 0
var speedDirection = Vector2.RIGHT
enum SpeState {STATIC,MOVE}
var speedState = SpeState.MOVE

var ifOnlyAttBase = false#
var attackType = [false,false,false,false]#
var damageMethod
var damagerType#有伤害加成的攻击目标
var damageBasic = 1#
var damage = 1
var damageAdd = 0
var damageEffect = 0


var ifProPierce = false#
var attRangeBasic = 100#
var attRange = attRangeBasic
var attRangeEffect = 0
var projectile = load("res://sence/projectiles.tscn")

#攻击 平时 死亡
var ifAoeHold = [false,false,false]#
var aoeModel = [Global.AoeModel.MONSTER,Global.AoeModel.MONSTER,Global.AoeModel.MONSTER]#
var aoeRange = [50,50,50]#
#自身状态数据
var nowEffect = [0,0,0,0,0,0,0,0,0,0]
var effUncencal = [0,0,0,0,0,0,0,0,0]
var nowEffGoodOrBad = [-1,-1,-1,-1,-1,-1,-1,-1,-1]
var effDefence = [false,false,false,false,false,false,false,false,false]
#攻击给予状态
var attEffGoodOrBad = [-1,-1,-1,-1,-1,-1,-1,-1,-1]#
var attackEffect = [false,false,false,false,false,false,false,false,false]#
#平时给予状态
var usuallyEffGoodOrBad = [1,1,1,1,1,1,1,1,1]#
var usuallyEffect#
#死亡给予状态
var deathEffGoodOrBad = [1,1,1,1,1,1,1]#
var deathEffect#

var ifFirstEffect = false#
var ifHealthEffect = false#
var healthEffValue = 0#
var ifDistanceEffect = false#

var attDefOrigin = [false,false,false,false]#
var attDefence = attDefOrigin
var healthDefValue = 0#
var attDefHealth#
var satDefValue = 0#
var attDefState#




func _init():
	pass
	
func _ready():
	pass
	
func firstSetting(soldierName):
	camp = Global.SoldierData[soldierName]["camp"]
	kind = Global.SoldierData[soldierName]["kind"]
	collKind = Global.SoldierData[soldierName]["collKind"]
	health = Global.SoldierData[soldierName]["health"]
	totalPictureNumber = Global.SoldierData[soldierName]["totalPictureNumber"]
	animationStart = Global.SoldierData[soldierName]["animationStart"]
	animationEnd = Global.SoldierData[soldierName]["animationEnd"]
	seaAniNumber = Global.SoldierData[soldierName]["seaAniNumber"]
	aniTimeBasic = Global.SoldierData[soldierName]["aniTimeBasic"]
	speedBasic = Global.SoldierData[soldierName]["speedBasic"]
	ifOnlyAttBase = Global.SoldierData[soldierName]["ifOnlyAttBase"]
	attackType = Global.SoldierData[soldierName]["attackType"]
	damageMethod = Global.SoldierData[soldierName]["damageMethod"]
	damagerType = Global.SoldierData[soldierName]["damagerType"]
	damageBasic = Global.SoldierData[soldierName]["damageBasic"]
	attRangeBasic = Global.SoldierData[soldierName]["attRangeBasic"]
	ifAoeHold = Global.SoldierData[soldierName]["ifAoeHold"]
	aoeModel = Global.SoldierData[soldierName]["aoeModel"]
	aoeRange = Global.SoldierData[soldierName]["aoeRange"]
	attEffGoodOrBad = Global.SoldierData[soldierName]["attEffGoodOrBad"]
	attackEffect = Global.SoldierData[soldierName]["attackEffect"]
	usuallyEffGoodOrBad = Global.SoldierData[soldierName]["usuallyEffGoodOrBad"]
	usuallyEffect = Global.SoldierData[soldierName]["usuallyEffect"]
	deathEffGoodOrBad = Global.SoldierData[soldierName]["deathEffGoodOrBad"]
	deathEffect = Global.SoldierData[soldierName]["deathEffect"]
	ifFirstEffect = Global.SoldierData[soldierName]["ifFirstEffect"]
	ifHealthEffect = Global.SoldierData[soldierName]["ifHealthEffect"]
	healthEffValue = Global.SoldierData[soldierName]["healthEffValue"]
	ifDistanceEffect = Global.SoldierData[soldierName]["ifDistanceEffect"]
	attDefOrigin = Global.SoldierData[soldierName]["attDefOrigin"]
	healthDefValue = Global.SoldierData[soldierName]["healthDefValue"]
	attDefHealth = Global.SoldierData[soldierName]["attDefHealth"]
	satDefValue = Global.SoldierData[soldierName]["satDefValue"]
	attDefState = Global.SoldierData[soldierName]["attDefState"]
	soldiername = soldierName
	
	Global.FightSence.reloadSence.connect(reload)
	
	#记录攻击免疫
	attDefence = attDefOrigin

	#设置碰撞层
	collision_layer = Global.LAyer[camp+1][0]
	collision_mask = Global.MAsk[camp+1][0]
	if kind == Global.Kind.SEA:
		collision_layer = Global.LAyer[camp+1][1]
		collision_mask = Global.MAsk[camp+1][1]
	#是否只攻击对方基地(限近战，碰到对方士兵和塔不停)
	if ifOnlyAttBase == true: collision_mask = Global.LAyer[camp+1][2]
	#把设置过的碰撞层导入射线检测的碰撞层
	$Collision1.collision_mask = collision_mask
	$Collision2.collision_mask = collision_mask
	#设置各种类士兵2号射线碰撞位置(以远程地对空和空对地为主)
	match collKind:
		Global.CollKind.LANDSKY: $Collision2.position = Vector2(-50*camp,-50*camp)
		Global.CollKind.SKY: $Collision2.position = Vector2(-50*camp,50*camp)
		Global.CollKind.SKYLAND: $Collision2.position = Vector2(0,50*camp)
	#如果有平时效果开启平时效果计时器
	if usuallyEffect != null: $usuallyTimer.start(Global.EffTime)
	#有开头效果的给予(速度攻击力都提升)
	if ifFirstEffect == true:
		damageAdd = Global.effect_calu(damageBasic,Global.Effect.ATTDAMAGE,null,null)
		speedAdd = Global.effect_calu(speedBasic,Global.Effect.SPEED,null,null)
		aniTimeCut = Global.effect_calu(aniTimeBasic,Global.Effect.SPEED,null,null)
		walkAni = Ani.AWALK#控制开始效果时使用不同的动画
		attack1Ani = Ani.AATTACK1
		standardAni = walkAni
	#动画基础数据导入并开始播放动画
	#$Sprite2D.texture = load("res://assets/soldiers/%s.png" % [soldierName])
	$Sprite2D.texture = load("res://assets/soldiers/"+soldierName+".png")
	$Sprite2D.hframes = totalPictureNumber
	changeAnimation(standardAni,currentState)
	pass

func _process(_delta):#每帧执行的部分
	#死亡判定
	if health <= 0&&currentState != State.DEATH: changeState(Ani.DEATH,State.DEATH)
	#直接给予伤害单体攻击时获得对方id
	if currentState == State.ATTACK: 
		other = $Collision1.get_collider()
		if ifFirstEffect == true:#解除开头效果并恢复动画
			damageAdd = 0
			speedAdd = 0
			aniTimeCut = 0
			walkAni = Ani.WALK
			attack1Ani = Ani.ATTACK1
			standardAni = walkAni
			ifFirstEffect = false
	#血量低于临界攻击力提升
	if health <= healthEffValue&&ifHealthEffect == true:
		damageAdd = Global.effect_calu(damageBasic,Global.Effect.ATTDAMAGE,null,null)
		ifHealthEffect = false
	#到一定距离内速度提升
	if ifDistanceEffect == true:
		speedAdd = Global.effect_calu(speedBasic,Global.Effect.SPEED,null,null)
		aniTimeCut = Global.effect_calu(aniTimeBasic,Global.Effect.SPEED,null,null)
	#血量低于临界攻击免疫变少
	if health <= healthDefValue&&attDefHealth != null:
		walkAni = Ani.AWALK
		attack1Ani = Ani.AATTACK1
		attDefence = attDefHealth
	#不同状态攻击免疫改变
	if attDefState != null:
		if currentState == satDefValue: attDefence = attDefState 
		else: attDefence = attDefOrigin
	#我方士兵控制，有开始状态的士兵处于开始状态时不能被控制

	if camp == Global.VILLAGE&&Global.Contrl == soldiername: 
		#if (collKind!=Global.CollKind.NARESPE)||(collKind==Global.CollKind.NARESPE&&ifFirstEffect==false): 
		contrl()

	#基础数据实时更改
	damage = damageBasic+damageAdd+damageEffect
	speed = Vector2(speedBasic+speedAdd+speedEffect,0)
	aniTime = aniTimeBasic-aniTimeCut-aniTimeEffect
	attRange = Vector2(attRangeEffect+attRangeBasic,0)
	$Collision1.target_position = attRange*Vector2(camp,0)
	$Collision2.target_position = attRange*Vector2(camp,0)

	
	#移动控制
	position += speed*camp*speedDirection*speedState
	position.x = clamp(position.x,90,700)#限制移动范围
	
	#测试用
	$Label.text = str(health)
	if Input.is_action_just_pressed("ui_select"):
		
		if camp == Global.MONSTER: 
			print(usuallyEffGoodOrBad)
	pass

func contrl():#玩家的单位控制
	if Input.is_action_just_pressed("ui_right")&&currentState != State.ATTACK: 
		changeState(Ani.WALK,State.PUSH)
	#防止攻击时还能继续前进
	if Input.is_action_just_pressed("ui_down"): changeState(Ani.STOP,State.STOP)
	if Input.is_action_just_pressed("ui_left"): changeState(Ani.WALK,State.BACK)
	pass
	
func testchangeState():
	$Collision1.force_raycast_update()
	$Collision2.force_raycast_update()#更新射线碰撞检测
	#第一碰撞
	if $Collision1.is_colliding():
		if currentAni != Ani.ATTACK1: changeState(attack1Ani,State.ATTACK)
	else: if currentAni == Ani.ATTACK1: changeState(standardAni,standardState)
	#第二碰撞,距离效果启用及停用,确保给距离效果是增值只赋值一次不是一直赋值
	if $Collision2.is_colliding()&&Global.Coll2IfUse[collKind] == true:
		if currentAni != Ani.ATTACK2&&collKind != Global.CollKind.NARESPE: 
			changeState(Ani.ATTACK2,State.ATTACK)
		if collKind == Global.CollKind.NARESPE&&ifDistanceEffect == false: ifDistanceEffect = true
	else: 
		if currentAni == Ani.ATTACK2&&collKind != Global.CollKind.NARESPE: 
			changeState(standardAni,standardState)
		if collKind == Global.CollKind.NARESPE: 
			speedAdd = 0 
			aniTimeCut = 0
			ifDistanceEffect = false
	#第一第二同时碰撞
	if $Collision1.is_colliding()&&$Collision2.is_colliding()&&collKind == Global.CollKind.SKYLAND:
		if currentAni != Ani.ATTACK3: changeState(Ani.ATTACK3,State.ATTACK)
	else: if currentAni == Ani.ATTACK3: changeState(standardAni,standardState)
	pass
	
func changeState(AniName,StaName):#入海出海的动作图片在每个动画的前面放
	if kind == Global.Kind.SEA:
		match StaName:
			State.PUSH,State.BACK:#入海
				if currentState == State.STOP||currentState == State.ATTACK:
					seaAni = seaAniNumber
					collision_layer = Global.LAyer[camp+1][1]
					
		match StaName:
			State.STOP,State.ATTACK:#出海
				if currentState == State.PUSH||currentState == State.BACK:
					seaAni = seaAniNumber
					collision_layer = Global.LAyer[camp+1][0]

	match StaName:
		State.DEATH:#最优先状态
			collision_layer = Global.deathLayer#不再能互动
			#changeTime = 0.6#标准死亡等待消失时间(总共0.6s)
			changeAnimation(AniName,StaName)
		State.ATTACK:
			if currentState == State.PUSH||currentState == State.STOP:
				changeAnimation(AniName,StaName)
		State.STOP:#攻击时候停止是在攻击完后保持静止
			if currentState != State.DEATH: 
				changeAnimation(AniName,StaName)
				standardState = State.STOP
				standardAni = Ani.STOP
	match StaName:
		State.PUSH,State.BACK:
			if currentState != State.DEATH&&currentState != StaName:
				changeAnimation(AniName,StaName)
				standardState = State.PUSH
				standardAni = walkAni
	#print(currentState)
	pass
	
func changeAnimation(AniName,StaName):
	
	match StaName:#SpeedState
		State.DEATH,State.ATTACK,State.STOP:
			speedState = SpeState.STATIC
	match StaName:
		State.PUSH,State.BACK:
			speedState = SpeState.MOVE
	match StaName:#SpeedDirection
		State.PUSH: speedDirection = Vector2.RIGHT
		State.BACK: speedDirection = Vector2.LEFT
			
	currentAni = AniName
	currentState = StaName#记录当前切换状态
	currentAnimationStart = animationStart[AniName]
	currentAnimationEnd = animationEnd[AniName]
	$Sprite2D.frame = animationStart[AniName]-seaAni

	$animationTimer.start(aniTime)
	pass

func attack():
	if attackType[Global.AttackType.IMMDAMAGE] == true||attackType[Global.AttackType.MAGIC] == true||attackType[Global.AttackType.EXPLODE] == true:
		match damageMethod:
			Global.DamageMethod.SINGAL:
				Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,other,Global.TRtype.VALCALU,null,null,null,null,null,null,attackType,damage,damagerType,attackEffect,attEffGoodOrBad)
				#func TRvalue_caluORcreate(caluType,damager,target,ifProPierce,damageMethod,proRange,aoeModel,aoeRange,ifAoeHold,attackType,damage,damagerType,giveEffect,giveEffGoodOrBad):
			Global.DamageMethod.AOE:
				Global.TRvalue_caluORcreate(null,other,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],null,attackType,damage,damagerType,attackEffect,attEffGoodOrBad)

	if attackType[Global.AttackType.PROJECTILE] == true:
			var projectileNew = projectile.instantiate()
			add_child(projectileNew)#射程伤害阵营
			projectileNew.position = Vector2(0,1.5)
			Global.TRvalue_caluORcreate(null,null,projectileNew,ifProPierce,damageMethod,attRange,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],ifAoeHold[Global.AoeSet.ATTACK],attackType,damage,damagerType,attackEffect,attEffGoodOrBad)
			#projectileNew.target = other
			#projectileNew.calu(
	pass

func _on_animationTimer_timeout():
	$Sprite2D.frame += 1
	if $Sprite2D.frame >= currentAnimationEnd:
		$Sprite2D.frame = currentAnimationStart
		seaAni = 0
		if is_instance_valid(other):#攻击执行
			match currentState:
				State.ATTACK: 
					if is_instance_valid(other): attack()
				State.DEATH:
					if deathEffect != null:#启动亡语效果
						Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.DEATH],aoeRange[Global.AoeSet.DEATH],ifAoeHold[Global.AoeSet.DEATH],null,null,null,deathEffect,deathEffGoodOrBad)
					queue_free()
	testchangeState()#状态切换检测
	pass 

func attributeTimer(effName):
	match effName:
		Global.Effect.ATTDAMAGE:
			damageEffect = Global.effect_calu(damageBasic,effName,nowEffGoodOrBad,effUncencal)
		Global.Effect.SPEED:
			speedEffect =  Global.effect_calu(speedBasic,effName,nowEffGoodOrBad,effUncencal)
			aniTimeEffect = Global.effect_calu(aniTimeBasic,effName,nowEffGoodOrBad,effUncencal)
		Global.Effect.ATTRANGE:
			attRangeEffect = Global.effect_calu(attRangeBasic,effName,nowEffGoodOrBad,effUncencal)
	await get_tree().create_timer(Global.EffTime).timeout
	match effName:
		Global.Effect.ATTDAMAGE:
			damageEffect = 0
		Global.Effect.SPEED:
			speedEffect = 0
			aniTimeEffect = 0
		Global.Effect.ATTRANGE:
			attRangeEffect = 0
	nowEffect[effName] = Global.OFFEFFECT
	effUncencal[effName] = Global.UNCENCAL
	pass
	
	
func posionTimer(effName):
	$poisonTimer.start(Global.HealthReduceTime)
	await get_tree().create_timer(Global.EffTime).timeout
	$poisonTimer.stop()
	nowEffect[effName] = Global.OFFEFFECT
	effUncencal[effName] = Global.UNCENCAL
	pass
	
func _on_poisonTimer_timeout():
	health += Global.EffValue[Global.Effect.POISON]*nowEffGoodOrBad[Global.Effect.POISON]*effUncencal[Global.Effect.POISON]
	pass

func fireTimer(effName):
	$fireTimer.start(Global.HealthReduceTime)
	await get_tree().create_timer(Global.EffTime).timeout
	$fireTimer.stop()
	nowEffect[effName] = Global.OFFEFFECT
	effUncencal[effName] = Global.UNCENCAL
	
	pass
	
func _on_fireTimer_timeout():
	health += Global.EffValue[Global.Effect.FIRE]*nowEffGoodOrBad[Global.Effect.FIRE]*effUncencal[Global.Effect.FIRE]
	pass

func _on_usuallyTimer_timeout():
	if currentState != State.DEATH: Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.NORMAL],aoeRange[Global.AoeSet.NORMAL],ifAoeHold[Global.AoeSet.NORMAL],null,null,null,usuallyEffect,usuallyEffGoodOrBad)
	pass 

func _on_input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("ui_mouse_left"):
		Global.Contrl = soldiername
		$Sprite2D.material = Global.OutLine
	pass 


func reload():

	queue_free()
	pass # Replace with function body.
