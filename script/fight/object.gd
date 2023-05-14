extends Area2D
var camp = 1#
var type = "soldier"#soldier tower skill base projectile
var kind = "land"#land sea sky
var coll2Pos#landSky Skyland SkyLine
var health = 1#
var healthUp = health
var collBox:Vector2##不用记录根据已读入数据推算
var soldierName = [null,null]#
var other

enum State {ATTACK,STOP,DEATH,BACK,PUSH,OUTSEA,FALL}
const ani = {"attack":0,"attackSec":1,"usual":2,"death":3}#usual = 2
var animation#
var currentState = State.PUSH
var currentAni = "walk"
var standardState = State.PUSH
var standardAni = "walk"
var seaState
var seaAni

var aniSpeed
var aniSpeedBasic = 1

var speed = Vector2(0,0)
var speedBasic = 0#
var speedDirection = Vector2.RIGHT
enum SpeState {STATIC,MOVE}
var speedState = SpeState.MOVE

var ifOnlyAttBase = false#
var attackType = [[false,false,false],[false,false,false]]#近 远 爆炸
#var damageMethod#
var damagerType=[[null],[null]]#有伤害加成的攻击目标
var damageBasic = [0,0]#
var damage= [0,0]#我方技能传递时此值为-1让aoe范围包括海陆空

var Projectile = preload("res://sence/fight/object/projectiles.tscn")
var attRangeBasic = [0,0]#
var attRange = [0,0]
var proSpeed = [0,0]#
var ifPriece = [false,false]#
var projectile#
var proSleepTime#
var proContinueTimes#
var proTimes = 0

#攻击 平时 死亡
var aoeModel = [null,null,null,null]#
var aoeRange = [null,null,null,null]#
var ifAoeHold = [false,false,false,false]#
#自身状态数据 #攻击1 攻击2 平时 死亡
var effTimerId = [null,null,null,null,null,null,null]
var nowEffect = [0,0,0,0,0,0,0]#记录伤害，速度，射程当前的效果值，区分好坏
var effTime = [[0,0,0,0,0],[0,0,0,0,0],[],[]]#后两个为平时，攻击持续效果的间隔给予数值的时间
var effValue = [[0,0],[0,0],[],[]]#平时效果保持伤害,攻击效果保持伤害,击退距离
var effTimes = [0,0,0,0]#效果持续：平时次数，攻击次数
var ifAoe##仅用于伤害判定给予效果时分辨效果来源
var effDefence = [false,false,false,false,false,false,false]#
var giveEffect = [[0,0,0,0,0,0],[0,0,0,0,0,0],[],[]]#攻击给予状态同时表示好坏
var healthEffValue = 0#低血量提升攻击力速度
var usualTime#
var shield = 0#
var attDefOrigin = [false,false,false]#
var attDefence = attDefOrigin



var usuallyEffect#平时给予状态
var usualEffValue
var deathEffect#死亡给予状态
var ifFirstEffect = false#
#var ifHealthEffect = false#
var ifDistanceEffect = false#
var attDefShield#
var satDefValue = 0#
var attDefState#

func _init():
	pass
	
func _ready():
	pass
	
func SetValue(soldier):
	for STSDatename in Global.STSData[soldier]:
		set(STSDatename,Global.STSData[soldier][STSDatename])
	pass
	
func SetAnimationAndCollBox(soldier):
	var spirte = SpriteFrames.new()#给动画播放器添加图片
	for i in animation.keys():
		spirte.add_animation(i)
		for j in animation[i]:
			var picture = load("res://assets/objects/%s/%s/%s/%s%s.png"% [type,soldier,i,i,j+1])
			spirte.add_frame(i,picture)
	$AnimatedSprite2D.sprite_frames = spirte
	changeAnimation(currentAni,currentState)
	#填充碰撞箱
	var newBox = RectangleShape2D.new()
	newBox.size = collBox
	$CollisionShape2D.shape = newBox
	pass
	
func firstSetting(soldier):
	Global.FightSence.reloadSence.connect(reload)
	name = soldier
	soldierName[0] = soldier
	nowEffect[Global.Effect.FREEZE] = SpeState.MOVE
	healthUp = health#记录血量上限
	if attDefShield != null: attDefence = attDefShield
	collision_mask = Global.MAsk[camp+1][0]#设置碰撞的笼罩层
	if ifOnlyAttBase == true:  collision_mask = Global.MAsk[camp+1][2]
	#把设置过的碰撞层导入射线检测的碰撞层
	$Collision1.collision_mask = collision_mask
	$Collision2.collision_mask = collision_mask
	pass
	
func reSet(soldier):
	soldierName[0] = null
	SetValue(soldier)
	SetAnimationAndCollBox(soldier)
	changeAnimation(currentAni,currentState)
	pass
	
func _process(_delta):#每帧执行的部分
	testchangeState()#状态切换检测	
	$Label.text = str(health)
	#基础数据实时更改/前是负属性后是正属性
	for i in 2:#攻击和攻击距离有两套随攻击使用的不同
		damage[i] = (damageBasic[i]+(damageBasic[i]*(-nowEffect[Global.Effect.ATTDAMAGE]
		+nowEffect[Global.Effect.ATTDAMAGE+Global.EffGood])))
		
		attRange[i] = Vector2(attRangeBasic[i]+(attRangeBasic[i]*(-nowEffect[Global.Effect.ATTRANGE]
		+nowEffect[Global.Effect.ATTRANGE+Global.EffGood])),0)
		
	speed = Vector2(speedBasic+(speedBasic*(-nowEffect[Global.Effect.SPEED]
	+nowEffect[Global.Effect.SPEED+Global.EffGood])),0)*Vector2(nowEffect[Global.Effect.FREEZE]*speedState,0)
	
	aniSpeed = (aniSpeedBasic+(aniSpeedBasic*(-nowEffect[Global.Effect.SPEED]
	+nowEffect[Global.Effect.SPEED+Global.EffGood])))*nowEffect[Global.Effect.FREEZE]
	
	$Collision1.target_position = attRange[0]*Vector2(camp,0)
	$Collision2.target_position = attRange[1]*Vector2(camp,0)
	$AnimatedSprite2D.speed_scale = aniSpeed
	
	if health <= 0&&currentState != State.DEATH&&currentState != State.FALL: #死亡判定
		$Collision1.collide_with_areas = false
		$Collision2.collide_with_areas = false
		$AnimatedSprite2D.material = null
		#死亡特效
		if animation.has("deathFall"): changeState("deathFall",State.FALL)
		else: changeState("death",State.DEATH)
			
	if currentState == State.FALL:#活塞虫坠机自爆
		position.y += 5
		if position.y >= Global.FightGroundY: 
			var attackAni = "attackSec"
			aoeRange[ani[attackAni]] = aoeRange[ani[attackAni]]*1.5#扩大爆炸范围
			Global.aoe_create(self,Global.CREATE,aoeModel[ani[attackAni]],aoeRange[ani[attackAni]],
			ifAoeHold[ani[attackAni]],attackType[ani[attackAni]],damage[ani[attackAni]],
			damagerType[ani[attackAni]],giveEffect[ani[attackAni]],effValue[ani[attackAni]],
			effTime[ani[attackAni]],effTimes[ani[attackAni]])
			changeState("death",State.DEATH)
	
	if health <=0 && !giveEffect[ani["death"]].is_empty()&&currentState == State.DEATH:#死亡效果
		var usual = ani["death"]
		Global.aoe_create(self,Global.CREATE,aoeModel[usual],aoeRange[usual],ifAoeHold[usual],
		null,null,null,giveEffect[usual],effValue[usual],effTime[usual],effTimes[usual])
		giveEffect[ani["death"]] = []

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
	pass
	
	if currentAni != "attackThr":
		if $Collision1.is_colliding():#第一碰撞
			if currentAni != "attack": 
				other = $Collision1.get_collider() #单体攻击时获得对方id 
				if soldierName[0] == "end": $un
				changeState("attack",State.ATTACK)
		else: 
			if currentAni == "attack": 
				changeState(standardAni,standardState)
		if $Collision2.is_colliding()&&currentAni != "attack":#第二碰撞
			if currentAni != "attackSec": 
				other = $Collision2.get_collider()
				changeState("attackSec",State.ATTACK)
		else: if currentAni == "attackSec": changeState(standardAni,standardState)
	pass
	
func changeState(AniName,StaName):#入海出海的动作图片在每个动画的前面放
	if kind == "sea":
		seaAni = AniName
		seaState = StaName
		if (StaName == State.ATTACK&&currentState == State.PUSH):#海军出海
			collision_layer = Global.LAyer[camp+1][0]#出海后不再入海
			StaName = State.OUTSEA
			AniName = "seaOut"
			$Collision1.collide_with_areas = false
	match StaName:
		#State.DEATH:#最优先状态
			#collision_layer = 0#不再能互动
			#changeTime = 0.6#标准死亡等待消失时间(总共0.6s)
		#State.ATTACK:if currentState == State.PUSH||currentState == State.STOP:pass
		State.STOP:#攻击时候停止是在攻击完后保持静止
			if currentState != State.DEATH: 
				standardState = State.STOP
				standardAni = "stop"
	match StaName:
		State.PUSH,State.BACK:
			if currentState != State.DEATH&&currentState != StaName:
				standardState = State.PUSH
				standardAni = "walk"
				proTimes = 0#归零多次射击的计数,避免射击不到最高次数就冷却
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
		State.PUSH: speedDirection = Vector2.RIGHT
		State.BACK: speedDirection = Vector2.LEFT
	currentAni = AniName
	currentState = StaName#记录当前切换状态
	$AnimatedSprite2D.play(AniName)
	pass

func _on_animated_sprite_2d_frame_changed():
	if $AnimatedSprite2D.frame == animation[$AnimatedSprite2D.animation]-1:
		match currentState:
			State.ATTACK: 
				if is_instance_valid(other): 
					if proContinueTimes == null:  attack()
					else: 
						if proTimes<proContinueTimes:#脉冲箭塔持续射击一会休息一下
							proTimes +=1
							attack()
							if proTimes == proContinueTimes:
								await get_tree().create_timer(proSleepTime,false).timeout
								proTimes = 0
			State.DEATH: 
				if camp == Global.MONSTER: Global.MonsterDeaths += 1
				queue_free()
		if currentState == State.OUTSEA: 
			changeState(seaAni,seaState)
			$Collision1.collide_with_areas = true
			kind = "land"
	pass

func attack():
	var attackAni = currentAni
	#第二攻击有数据才换数据否则两组攻击数据一样
	if attackAni == "attackSec"&&damageBasic[ani["attackSec"]] == null: attackAni = "attack"
	
	if projectile == null:
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
			if attackType[ani[attackAni]][Global.AttackType.EXPLODE] == true: queue_free()#近战AOE且是爆炸伤害类型->只有自爆
			if soldierName[0] == "assassinFirst": reSet(soldierName[1])
	else:#远程
		var attTimes = 1
		if currentAni == "attackThr":#第三情况为同时攻击两个目标，限空军
			attackAni = "attack"
			attTimes = 2
		for i in attTimes:
			var newPro = Projectile.instantiate()
			Global.root.add_child(newPro)
			newPro.collision_mask = collision_mask
			newPro.camp = camp
			newPro.projectile = projectile[ani[attackAni]]
			newPro.position = position 
			#Global.ProPos[projectile[ani[attackAni]]]
			newPro.proRange = attRange[ani[attackAni]]
			newPro.proSpeed = proSpeed[ani[attackAni]]
			newPro.ifPriece = ifPriece[ani[attackAni]]
			if currentAni == "attackThr"&&attackAni == "attack":  attackAni = "attackSec"

			Global.aoe_create(newPro,Global.TRANSFER,aoeModel[ani[attackAni]],aoeRange[ani[attackAni]],
			ifAoeHold[ani[attackAni]],attackType[ani[attackAni]],damage[ani[attackAni]],
			damagerType[ani[attackAni]],giveEffect[ani[attackAni]],effValue[ani[attackAni]],
			effTime[ani[attackAni]],effTimes[ani[attackAni]])
			newPro.firstSetting()
	pass
	
	
func effectTimer(effName,effKeepTime,GoodOrBad):
	var this = effName
	if GoodOrBad == Global.EFFGOOD: this = effName+Global.Effect.DAMAGE
	if effName == Global.Effect.FREEZE:
		#$AnimatedSprite2D.pause()
		$Collision1.collide_with_areas = false
		$Collision2.collide_with_areas = false
	if effKeepTime!=null: 
		var effTimer = Timer.new()
		effTimer.timeout.connect(effectTimerTimeout.bind(effName,GoodOrBad))
		effTimer.one_shot = true
		add_child(effTimer)
		effTimer.start(effKeepTime)
		effTimerId[this] = effTimer
	pass
	
func effectTimerTimeout(effName,GoodOrBad):
	var this = effName
	if GoodOrBad == Global.EFFGOOD: this = effName+Global.Effect.DAMAGE
	nowEffect[this] = 0
	if effName == Global.Effect.FREEZE:
		nowEffect[this] = SpeState.MOVE
		$Collision1.collide_with_areas = true
		$Collision2.collide_with_areas = true
	if effTimerId[this] != null: effTimerId[this].queue_free()
	pass
	

func reload():
	queue_free()
	pass 



















