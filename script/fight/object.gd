extends Area2D
var camp = 1#
var type = "soldier"#soldier tower skill base projectile
var kind = "land"#land sea sky
var coll2Pos#landSky Skyland SkyLine
var health = 1#
var healthUp = health
var collBoxCut = 0#
var collBoxPro = 0#
var collBox:Vector2##不用记录根据已读入数据推算
var soldierName = [null,null]#
var other
var Death = false

enum State {ATTACK,STOP,DEATH,BACK,PUSH,OUTSEA,FALL}
const ani = {"attack":0,"attackSec":1,"death":2,"usual":3}#usual = 2
var spirte
var animation#
var souEff = {"attack":null,"hurt":null,"attackSec":null,"walk":null,"stop":null,"death":null}
var souEffValue:Dictionary
var stepSe=[null,null,null,null]
var particles = {"hurt":null,"attack":null,"attackSec":null,"walk":null,"stop":null,"death":null}
var particlesValue:Dictionary

var currentState = State.PUSH
var currentAni = "walk"
var standardState = State.PUSH
var standardAni = "walk"

var aniSpeed
var aniSpeedBasic = 1

var speed = 0
var speedBasic = 0#
var speedDirection = 1
enum SpeState {STATIC,MOVE}
var speedState = SpeState.MOVE

var ifOnlyAttBase = false#
var attackType = [[false,false,false],[false,false,false],[false,false,false]]#近 远 爆炸
#var damageMethod#
var damagerType=[[null],[null],[null]]#有伤害加成的攻击目标
var damageBasic = [0,0,0]#
var damage= [0,0]#我方技能传递时此值为-1让aoe范围包括海陆空

var Projectile = preload("res://sence/fight/object/projectiles.tscn")
var attRangeBasic = [0,0]#
var attRange = [0,0]
var proSpeed = [0,0]#
var proPos = [0,0,0,0]#
var proDir = [0,0,0,0]#
var ifPriece = [false,false]#
var projectile = []#
var proSleepTime#
var proContinueTimes#
var proTimes = 0

#攻击 平时 死亡
var aoeModel = [null,null,null,null]#
var aoeRange = [null,null,null,null]#
var ifAoeHold = [false,false,false,false]#
#自身状态数据 #攻击1 攻击2 平时 死亡
var effTimerId = [null,null,null,null,null,null,null,null,null]
#var holdDamageTimes = {}
var nowEffect = [0,0,0,0,0,0,0,0,0]#记录伤害，速度，射程当前的效果值，区分好坏
var effTime = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]#后两个为平时，攻击持续效果的间隔给予数值的时间
var effValue = [[0,0,0],[0,0,0],[0,0,0],[0,0,0]]#平时效果保持伤害,攻击效果保持伤害,击退距离
var effTimes = [[0,0],[0,0],[0,0],[0,0]]#效果持续：平时次数，攻击次数
var ifAoe##仅用于伤害判定给予效果时分辨效果来源
var effDefence = [false,false,false,false,false,false,false]#
var giveEffect = [[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0],[0,0,0,0,0,0,0]]#攻击给予状态同时表示好坏
var deathAttType#
var usualTime#
var dropSpeed#
var firstAttack = false#
var unSee = false#
var tpDistance#
var shield = 0#
var attDefOrigin = [false,false,false]#
var attDefence = attDefOrigin
var attDefShield#

#var startDrop = false#
#var healthEffValue = -100#低血量提升攻击力速度
#var healthTpDistance#
#var tp = true#
#var seaState
#var seaAni
#var usuallyEffect#平时给予状态
#var usualEffValue
#var deathEffect#死亡给予状态
#var ifFirstEffect = false#
##var ifHealthEffect = false#
#var ifDistanceEffect = false#
#var satDefValue = 0#
#var attDefState#

func _init():
	pass
	
func _ready():
	pass
	
func SetValue(soldier):
	for STSDatename in Global.STSData[soldier]:
		set(STSDatename,Global.STSData[soldier][STSDatename])
	if dropSpeed != null: dropSpeed = int(dropSpeed)
	soldierName = soldierName.duplicate()
	pass
	
func SetAnimationAndCollBox(soldier):
	addSoundAndParticles()
	#if is_instance_valid(spirte) == true: spirte.free()
	spirte = SpriteFrames.new()#给动画播放器添加图片
	for i in animation.keys():
		spirte.add_animation(i)
		#if i == "death": spirte.set_animation_loop(i,false)#设置死亡停留动画
		for j in animation[i]:
			var picture = load("res://assets/objects/%s/%s/%s/%s%s.png"% [type,soldier,i,i,j+1])
			spirte.add_frame(i,picture)
	$AnimatedSprite2D.sprite_frames = spirte
	changeAnimation(currentAni,currentState)
	#填充碰撞箱
	var newBox = RectangleShape2D.new()
	newBox.size = collBox-Vector2(collBoxCut,0)
	$CollisionShape2D.shape = newBox
	$CollisionShape2D.position.x = collBoxPro
	pass
	
func addSoundAndParticles():
	for i in souEffValue: 
		if souEff.has(i):
			souEff[i] = AudioStreamPlayer.new()
			souEff[i].stream = load("res://assets/music/se/%s/%s.ogg"%[type,souEffValue[i]])
			add_child(souEff[i])
	for i in particlesValue: 
		if particles.has(i):
			if i == "hurt": $cover.material = load("res://rescourse/%s.tres"%particlesValue[i]) 
			else: particles[i] = get_node("particles/%s"%particlesValue[i])
	pass
	
func firstSetting(soldier):
	$cover.visible = false
#	if kind == "land":
#		for i in 4:
#			stepSe[i] =  AudioStreamPlayer.new()
#			stepSe[i].stream = load("res://assets/music/se/soldier/step/1/grass%s.ogg"%(i+1))
#			add_child(stepSe[i])
	#$outLine.visible = false
	Global.FightSence.reloadSence.connect(reload)
	name = soldier
	soldierName[0] = soldier
	nowEffect[Global.Effect.FREEZE] = SpeState.MOVE
	healthUp = health#记录血量上限
	if attDefShield != null: attDefence = attDefShield
	collMask()
	pass
	
func collMask():
	collision_mask = Global.MAsk[camp+1][0]#设置碰撞的笼罩层
	if ifOnlyAttBase == true:  collision_mask = Global.MAsk[camp+1][2]
	$Collision1.collision_mask = collision_mask
	$Collision2.collision_mask = collision_mask
	pass
	
func reSet(soldier):
	soldierName[0] = null
	SetValue(soldier)
	SetAnimationAndCollBox(soldier)
	collMask()
	pass
	
func _process(_delta):#每帧执行的部分
	if currentState == State.FALL:  position.y += dropSpeed
	$Label.text = str(health)

	for i in souEff: 
		if souEff[i] != null: souEff[i].set_volume_db(Global.SeDB)#时刻保持音量与全局音量一致
#	if kind == "land": for i in stepSe: i.set_volume_db(Global.SeDB/4)
	#基础数据实时更改/前是负属性后是正属性
	for i in 2:#攻击和攻击距离有两套随攻击使用的不同
		damage[i] = (damageBasic[i]+(damageBasic[i]*(nowEffect[Global.Effect.ATTDAMAGE]
		+nowEffect[Global.Effect.ATTDAMAGE+Global.EffGood])))
		
		attRange[i] = attRangeBasic[i]+(attRangeBasic[i]*(nowEffect[Global.Effect.ATTRANGE]
		+nowEffect[Global.Effect.ATTRANGE+Global.EffGood]))
		
	speed = (speedBasic+(speedBasic*(nowEffect[Global.Effect.SPEED]
	+nowEffect[Global.Effect.SPEED+Global.EffGood])))*nowEffect[Global.Effect.FREEZE]
	
	#aniSpeed = (aniSpeedBasic+(aniSpeedBasic*(nowEffect[Global.Effect.SPEED]
	#+nowEffect[Global.Effect.SPEED+Global.EffGood])))*nowEffect[Global.Effect.FREEZE]
	
	$Collision1.target_position = Vector2(attRange[0]*camp,0)
	$Collision2.target_position = Vector2(attRange[1]*camp,0)
	if type == "soldier": aniSpeedBasic = speed+0.2
	$AnimatedSprite2D.speed_scale = aniSpeedBasic
	
	if health <= 0&&currentState != State.DEATH: #死亡判定
		#&&currentState != State.FALL
		firstDeathSet()
		#if animation.has("deathFall"): changeState("deathFall",State.FALL)
	else: testchangeState()#状态切换检测
	if Input.is_action_just_pressed("ui_select"):#测试用
		if camp == Global.MONSTER:
			#print(speedEffect)
			pass
	pass

func testchangeState():
	$Collision1.force_raycast_update()
	$Collision2.force_raycast_update()#更新射线碰撞检测
	#两个攻击范围同时碰到同时进攻,限远程
	if $Collision1.is_colliding()&&$Collision2.is_colliding()&&animation.has("attackThr")==true:
		if currentAni != "attackThr": changeState("attackThr",State.ATTACK)
	else: if currentAni == "attackThr": changeState(standardAni,standardState)

	if currentAni != "attackThr":
		if $Collision1.is_colliding():#第一碰撞
			other = $Collision1.get_collider() #单体攻击时获得对方id
			if currentAni != "attack":
				changeState("attack",State.ATTACK) 
				if unSee == true: 
					collision_layer = Global.LAyer[camp+1][0]
					$AnimatedSprite2D.modulate.a = 1
				if tpDistance != null&&other.type != "base"&&health>0: 
#					if tpDistance > 0:
					position.x += tpDistance*camp#末影人瞬移
					tpDistance = 0#低血量tp到基地
#				if startDrop == true:
#					$Collision1.collide_with_areas = false
#					reSet(soldierName[1])
#					changeState("stop",State.FALL)
		else: 
			if currentAni == "attack": 
				if unSee == true: 
					collision_layer = Global.LAyer[camp+1][1]
					$AnimatedSprite2D.modulate.a = 0.5
				changeState(standardAni,standardState)
				
		if $Collision2.is_colliding()&&currentAni != "attack":#第二碰撞
			other = $Collision2.get_collider()
			if currentAni != "attackSec": 
				changeState("attackSec",State.ATTACK)
		else: if currentAni == "attackSec": changeState(standardAni,standardState)
	pass
	
func hurt():
	souEff["hurt"].playing = true
	$cover.visible = true
	await get_tree().create_timer(0.2,false).timeout
	$cover.visible = false
	pass
	
func changeState(AniName,StaName):#入海出海的动作图片在每个动画的前面放
#	if kind == "sea":
#		seaAni = AniName
#		seaState = StaName
#		if (StaName == State.ATTACK&&currentState == State.PUSH):#海军出海
#			collision_layer = Global.LAyer[camp+1][0]#出海后不再入海
#			StaName = State.OUTSEA
#			AniName = "seaOut"
#			$Collision1.collide_with_areas = false
	match StaName:
#		State.DEATH:#最优先状态
#			firstDeathSet()
#			finalDeathSet()
			#aniSpeedBasic = 1
			#collision_layer = 0#不再能互动
			#changeTime = 0.6#标准死亡等待消失时间(总共0.6s)
		#State.ATTACK:if currentState == State.PUSH||currentState == State.STOP:pass
		State.STOP:#攻击时候停止是在攻击完后保持静止
			if currentState != State.DEATH: 
				standardState = State.STOP
				standardAni = "stop"
				proTimes = 0
	match StaName:
		State.PUSH,State.BACK:
			if currentState != State.DEATH&&currentState != StaName:
				standardState = State.PUSH
				standardAni = "walk"
				#proTimes = 0#归零多次射击的计数,避免射击不到最高次数就冷却
	changeAnimation(AniName,StaName)
	pass
	
func changeAnimation(AniName,StaName):
	match StaName:#SpeedState
		State.DEATH,State.ATTACK,State.STOP,State.OUTSEA,State.FALL:
			speedState = SpeState.STATIC
	match StaName:
		State.PUSH,State.BACK:
			speedState = SpeState.MOVE
	match StaName:#SpeedDirection
		State.PUSH: speedDirection = 1
		State.BACK: speedDirection = -1
	currentAni = AniName
	currentState = StaName#记录当前切换状态
	$AnimatedSprite2D.play(AniName)
	pass

func _on_animated_sprite_2d_frame_changed():
	$cover.texture = spirte.get_frame_texture(currentAni,$AnimatedSprite2D.frame)
	#$outLine.texture = spirte.get_frame_texture(currentAni,$AnimatedSprite2D.frame)
	if $AnimatedSprite2D.frame == animation[$AnimatedSprite2D.animation]-1:
		match currentState:
			State.PUSH,State.BACK:
				if souEff["walk"] != null: souEff["walk"].playing = true
				if particles["walk"] != null: particles["walk"].emitting = true
#				var stepRand = randf_range(0,3)
#				stepSe[stepRand].playing = true
		match currentState:
			State.ATTACK: 
				if is_instance_valid(other) == true: 
					if proTimes!=proContinueTimes:
						var nowAni = currentAni
						if currentAni == "attackThr": 
							nowAni = "attack"
							if souEff["attackSec"] != null: souEff["attackSec"].playing = true
							if particles["attackSec"] != null: particles["attackSec"].emitting = true
						if souEff[nowAni] != null: souEff[nowAni].playing = true
						if particles[nowAni] != null: particles[nowAni].emitting = true
					if proContinueTimes == null:  attack()
					else: 
						if proTimes<proContinueTimes:#脉冲箭塔持续射击一会休息一下
							proTimes +=1
							attack()
							if proTimes == proContinueTimes:
								await get_tree().create_timer(proSleepTime,false).timeout
								proTimes = 0
			#State.DEATH:
#		if currentState == State.OUTSEA: 
#			changeState(seaAni,seaState)
#			$Collision1.collide_with_areas = true
#			kind = "land"
	pass

func attack():
	var attackAni = currentAni
	if attackAni == "attackSec"&&damageBasic[ani["attackSec"]] == null: 
		attackAni = "attack"#第二攻击有数据才换数据否则两组攻击数据一样
	
	if projectile.is_empty():
		if aoeRange[ani[attackAni]] == null:#近战单体
			Global.damage_Calu(other,Global.damCaluType.ATTEFF,attackType[ani[attackAni]],
			damage[ani[attackAni]],damagerType[ani[attackAni]],giveEffect[ani[attackAni]],
			effValue[ani[attackAni]],effTime[ani[attackAni]],effTimes[ani[attackAni]],Global.IfAoeType.NONE)
		else:#近战AOE
			#Global.damage_Calu(body,Global.TRANSFER,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,null)
			if attackType[ani[attackAni]][Global.AttackType.EXPLODE] == true: other = self
			Global.aoe_create(other,Global.CREATE,aoeModel[ani[attackAni]],aoeRange[ani[attackAni]],
			ifAoeHold[ani[attackAni]],attackType[ani[attackAni]],damage[ani[attackAni]],
			damagerType[ani[attackAni]],giveEffect[ani[attackAni]],effValue[ani[attackAni]],
			effTime[ani[attackAni]],effTimes[ani[attackAni]])
			if attackType[ani[attackAni]][Global.AttackType.EXPLODE] == true:
				$AnimatedSprite2D.visible = false
				firstDeathSet()#近战AOE且是爆炸伤害类型->只有自爆
			if firstAttack == true: 
				reSet(soldierName[1])
				firstAttack = false
	else:#远程
		var attTimes = 1
		if currentAni == "attackThr":#第三情况为同时攻击两个目标，限空军
			attackAni = "attack"
			attTimes = 2
		for i in attTimes:
			if i == 1&&attTimes == 2:  attackAni = "attackSec"
			var newPro = Projectile.instantiate()
			newPro.collision_mask = collision_mask
			newPro.camp = camp
			newPro.projectile = projectile[ani[attackAni]]
			newPro.proRange = attRange[ani[attackAni]]
			newPro.proSpeed = proSpeed[ani[attackAni]]
			newPro.proDir = Vector2(proDir[ani[attackAni]],proDir[ani[attackAni]+2])
			newPro.ifPriece = ifPriece[ani[attackAni]]
			Global.aoe_create(newPro,Global.TRANSFER,aoeModel[ani[attackAni]],
			aoeRange[ani[attackAni]],ifAoeHold[ani[attackAni]],attackType[ani[attackAni]],
			damage[ani[attackAni]],damagerType[ani[attackAni]],giveEffect[ani[attackAni]],
			effValue[ani[attackAni]],effTime[ani[attackAni]],effTimes[ani[attackAni]])
			newPro.position = position+Vector2(proPos[ani[attackAni]],
			proPos[ani[attackAni]+2])
			Global.root.add_child(newPro)
	pass
	
func firstDeathSet():
	$AnimatedSprite2D.material = null
	$Collision1.collide_with_areas = false
	$Collision2.collide_with_areas = false
	$cover.visible = false
	$outLine.visible = false
	collision_layer = 0
	#if soldierName[0]=="cave": Global.CaveHas = false
	if is_in_group("villageSoldier"): remove_from_group("villageSoldier")
	if is_in_group("monsterSoldier"): remove_from_group("monsterSoldier")
	if is_in_group("creeper"): remove_from_group("creeper")
	souEff["death"].playing = true
	changeState("death",State.DEATH)
	finalDeathSet()
	pass
	
func finalDeathSet():
	if type=="soldier": await get_tree().create_timer(0.8,false).timeout
	if particles["death"] != null: particles["death"].emitting = true
	$AnimatedSprite2D.visible = false
	if deathAttType != null:#死亡效果
#Global.aoe_create(self,Global.CREATE,aoeModel,aoeRange,ifAoeHold,
#attackType,damage,damagerType,
		var i = ani[deathAttType]
		Global.aoe_create(self,Global.CREATE,aoeModel[i],aoeRange[i],ifAoeHold[i],
		attackType[i],damageBasic[i],damagerType[i],giveEffect[i],effValue[i],
		effTime[i],effTimes[i])
	#if camp == Global.MONSTER: Global.MonsterDeaths += 1
	await get_tree().create_timer(2,false).timeout
	queue_free()
	pass
	
func effectTimer(effName,effKeepTime,effKeepTimes,effDam,GoodOrBad):
	var this = effName
	if GoodOrBad == Global.EFFGOOD: this += Global.EffGood
	if effName == Global.Effect.FREEZE:
		$Collision1.collide_with_areas = false
		$Collision2.collide_with_areas = false
	#if effKeepTime!=null: 
	var effTimer = Timer.new()
	effTimer.timeout.connect(effectTimerTimeout.bind(effName,effKeepTimes,effDam,GoodOrBad))
	effTimer.one_shot = true
	if effKeepTimes != null: effTimer.one_shot = false
	add_child(effTimer)
	effTimer.start(effKeepTime)
	effTimerId[this] = effTimer
	pass
	
func effectTimerTimeout(effName,effKeepTimes,effDam,GoodOrBad):
	var this = effName
	if GoodOrBad == Global.EFFGOOD: this += Global.EffGood
	if effName == Global.Effect.HOLDAMAGE:
		if health+effDam<=healthUp: health += effDam
		else: health = healthUp
		nowEffect[this] += 1 
		if nowEffect[this] == effKeepTimes:
			effTimerId[this].queue_free()
			nowEffect[this] = 0
	else:
		nowEffect[this] = Global.OFFEFFECT
		if effName == Global.Effect.FREEZE:
			nowEffect[this] = SpeState.MOVE
			$Collision1.collide_with_areas = true
			$Collision2.collide_with_areas = true
		if effTimerId[this] != null: effTimerId[this].queue_free()
	pass

func reload(): queue_free()























