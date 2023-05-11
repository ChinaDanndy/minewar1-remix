extends Area2D
var camp#
var type#
var typeName
var kind#
var collKind#
var health = 1#
var healthUp = health

var collBox:Vector2##不用记录根据已读入数据推算
var soldierName = [null,null,null]#
var other

enum Ani {WALK,ATTACK1,ATTACK2,ATTACK3,STOP,DEATH}
enum State {ATTACK,STOP,DEATH,BACK,PUSH}
var animation#
var aniName##不用读取用于区别塔和士兵各有哪些动画名
var seaAniNumber#
var currentState = State.PUSH
var currentAni = "walk"
var standardState = State.PUSH
var standardAni = "walk"
var seaAni = 0

var aniSpeed
var aniSpeedBasic = 1
var aniTimeBasic = 1#标准图片切换间隔

var speedBasic = 0.6#
var speed = Vector2(0,0)
var speedDirection = Vector2.RIGHT
enum SpeState {STATIC,MOVE}
var speedState = SpeState.MOVE

var ifOnlyAttBase = false#
var attackType = [false,false,false]#近 远 爆炸
var damageMethod#
var damagerType=[null]#有伤害加成的攻击目标
var damageBasic = 1#
var damage = 1#我方技能传递时此值为-1让aoe范围包括海陆空

var Projectile = preload("res://sence/fight/object/projectiles.tscn")
var attRangeBasic = 100#
var attRange = attRangeBasic
var projectile#
var proSleepTime#
var proContinueTimes#
var proTimes = 0

#攻击 平时 死亡
var aoeModel = [0,0,0]#
var aoeRange = [0,0,0]#
var ifAoeHold = [false,false,false]#
#自身状态数据
var effTimerId = [null,null,null,null,null,null,null]
var nowEffect = [0,0,1,0,0,0,0,0,0]#记录伤害，速度，射程当前的效果值，区分好坏
var effTime = [0,0,0,0,0,0]#后两个为平时，攻击持续效果的间隔给予数值的时间
var effValue = [0,0,0]#平时效果保持伤害,攻击效果保持伤害,击退距离
var effTimes = [0,0]#效果持续：平时次数，攻击次数
var ifAoe##仅用于伤害判定给予效果时分辨效果来源
var effDefence = [false,false,false,false,false,false,false]#
var attackEffect = [0,0,0,0,0,0,0]#攻击给予状态同时表示好坏
var usuallyEffect#平时给予状态
var deathEffect#死亡给予状态

var ifFirstEffect = false#
var ifHealthEffect = false#
var healthEffValue = 0#
var ifDistanceEffect = false#

var shield = 0#
var attDefOrigin = [false,false,false]#
var attDefence = attDefOrigin
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
	for i in aniName:
		spirte.add_animation(i)
		for j in animation[i]:
			var picture = load("res://assets/objects/%s/%s/%s/%s%s.png"% [typeName,soldier,i,i,j+1])
			spirte.add_frame(i,picture)
	$AnimatedSprite2D.sprite_frames = spirte
	changeAnimation(standardAni,currentState)
	#填充碰撞箱
	var newBox = RectangleShape2D.new()
	newBox.size = collBox
	$CollisionShape2D.shape = newBox
	pass
	
func firstSetting(soldier):
	Global.FightSence.reloadSence.connect(reload)
	name = soldier
	soldierName[0] = soldier
	collision_mask = Global.MAsk[camp+1][0]#设置碰撞层
	attDefence = attDefOrigin#记录攻击免疫
	healthUp = health#记录血量上限
	if attDefShield != null: attDefence = attDefShield
	#把设置过的碰撞层导入射线检测的碰撞层
	$Collision1.collision_mask = collision_mask
	$Collision2.collision_mask = collision_mask
	pass
	
func reSet(soldier):
	SetValue(soldier)
	SetAnimationAndCollBox(soldier)
	changeAnimation(currentAni,currentState)
	pass
	
func _physics_process(_delta):#每帧执行的部分
	testchangeState()#状态切换检测
	if currentState == State.ATTACK: #单体攻击时获得对方id 
		other = $Collision1.get_collider()	
	$Label.text = str(health)
	#基础数据实时更改
	damage = damageBasic+nowEffect[0]+nowEffect[5]
	speed = Vector2(speedBasic+nowEffect[1]+nowEffect[6],0)*Vector2(nowEffect[2],0)
	aniSpeed = aniSpeedBasic+nowEffect[4]+nowEffect[8]
	attRange = Vector2(attRangeBasic+nowEffect[3]+nowEffect[7],0)
	$Collision1.target_position = attRange*Vector2(camp,0)
	$Collision2.target_position = attRange*Vector2(camp,0)
	$AnimatedSprite2D.speed_scale = aniSpeed
	if Input.is_action_just_pressed("ui_select"):#测试用
		if camp == Global.MONSTER: pass
			#print(speedEffect)
	pass

func testchangeState():
	$Collision1.force_raycast_update()
	$Collision2.force_raycast_update()#更新射线碰撞检测
	#第一碰撞
	if $Collision1.is_colliding():
		if currentAni != "attack": 
			changeState("attack",State.ATTACK)
	else: 
		if currentAni == "attack": changeState(standardAni,standardState)
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
			collision_layer = 0#不再能互动
			$Collision1.collision_mask = 0
			$Collision1.enabled = false
			$Collision2.collision_mask = 0
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
	$AnimatedSprite2D.play(AniName,aniTimeBasic) #if nowEffect[Global.Effect.FREEZE] == 1: 
	pass

func attack():
	match damageMethod:
		Global.DamageMethod.NEARSINGLE:
			Global.damage_Calu(other,Global.damCaluType.ATTEFF,attackType,damage,damagerType,attackEffect,effValue,effTime,effTimes,Global.IfAoeType.NONE)
			#damage_Calu(damager,type,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes):
		Global.DamageMethod.NEARAOE:
			#Global.damage_Calu(body,Global.TRANSFER,attackType,damage,damagerType,giveEffect,effValue,effTime,effTimes,null)
			if attackType[Global.AttackType.EXPLODE] == true: 
				Global.aoe_create(self,Global.CREATE,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],ifAoeHold[Global.AoeSet.ATTACK],attackType,damage,damagerType,attackEffect,effValue,effTime,effTimes)
				queue_free()#近战AOE且是爆炸伤害类型->只有自爆
			else:  Global.aoe_create(other,Global.CREATE,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],ifAoeHold[Global.AoeSet.ATTACK],attackType,damage,damagerType,attackEffect,effValue,effTime,effTimes)
		Global.DamageMethod.FAR:
			var newPro = Projectile.instantiate()
			add_child(newPro)
			newPro.position = Global.ProPos[projectile]
			newPro.projectile = projectile
			newPro.proRange = attRange
			Global.aoe_create(newPro,Global.TRANSFER,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],ifAoeHold[Global.AoeSet.ATTACK],attackType,damage,damagerType,attackEffect,effValue,effTime,effTimes)
			newPro.firstSetting()
	pass


func _on_animated_sprite_2d_animation_looped():
	match currentState:
		State.ATTACK: 
			if is_instance_valid(other): 
				if proContinueTimes == null: attack()
				else: 
					if proTimes<proContinueTimes:#脉冲箭塔持续射击一会休息一下
						proTimes +=1
						attack()
						if proTimes == proContinueTimes:
							await get_tree().create_timer(proSleepTime,false).timeout
							proTimes = 0
		State.DEATH:
			if deathEffect != null:#启动亡语效果
				pass
				#Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.DEATH],aoeRange[Global.AoeSet.DEATH],aoeTime[Global.AoeSet.DEATH],aoeTimes[Global.AoeSet.DEATH],null,null,null,deathEffect,effValue,effTime,effTimes)
			queue_free()
	pass

func effectTimer(effName,effKeepTime,GoodOrBad):
	var this = effName
	if GoodOrBad == Global.EFFGOOD: this = effName+4
	if effName == Global.Effect.FREEZE:
		$AnimatedSprite2D.pause()
		$Collision1.enabled = false
		pass
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
	if GoodOrBad == Global.EFFGOOD: this = effName+4
	if effName == Global.Effect.SPEED: nowEffect[this+2]=0
	nowEffect[this] = 0
	if effName == Global.Effect.FREEZE:
		$AnimatedSprite2D.play()
		$Collision1.enabled = true
		nowEffect[this] = 1
		pass
	if effTimerId[this] != null: effTimerId[this].queue_free()
	pass
	
func holdDamageTimer(effKeepTime,effKeepTimes,effDamageValue):
	var effTimer = Timer.new()
	effTimer.timeout.connect(holdDamageTimerOut.bind(0,effKeepTimes,effTimer,effDamageValue))
	add_child(effTimer)
	effTimer.start(effKeepTime)
	pass
	
func holdDamageTimerOut(Times,effKeepTimes,Id,effDamageValue):
	health += effDamageValue
	Times += 1
	if Times == effKeepTimes: Id.queue_free()
	pass

func _on_usuallyTimer_timeout():
	#if currentState != State.DEATH: Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.NORMAL],aoeRange[Global.AoeSet.NORMAL],aoeTime[Global.AoeSet.NORMAL],aoeTimes[Global.AoeSet.NORMAL],null,null,null,usuallyEffect,effValue,effTime,effTimes)
	pass 


func reload():
	queue_free()
	pass 









