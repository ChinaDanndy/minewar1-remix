extends CharacterBody2D
var camp#
var type#
var kind#
var collKind#
var health = 1#
var healthUp = health
var towKeepTime#
var collBox = Vector2(0,0)##不用记录根据已读入数据推算

var a = 2

var soldierName = [null,null,null]#
var other


enum Ani {WALK,ATTACK1,ATTACK2,ATTACK3,STOP,DEATH}
enum State {ATTACK,STOP,DEATH,BACK,PUSH}

#var totalPictureNumber = 1#
#var frame
#var animationStart = [0,0,0,0,0,0]#
#var animationEnd = [0,0,0,0,0,0]#

var animation#
var aniName 
var seaAniNumber#
var currentState = State.PUSH
var currentAni = "walk"
var standardState = State.PUSH
var standardAni = "walk"
var seaAni = 0
#var currentAnimationStart = animationStart[currentAni]
#var currentAnimationEnd = animationEnd[currentAni]

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
var attackType = [false,false,false]#近 远 爆炸
var damageMethod
var damagerType=[null]#有伤害加成的攻击目标
var damageBasic = 1#
var damage = 1
var damageAdd = 0
var damageEffect = 0

var attRangeBasic = 100#
var attRange = attRangeBasic
var attRangeEffect = 0
var proSence = load("res://sence/projectiles.tscn")
var projectile = Global.Projectile.ARROW1#
var proMode = Global.ProMode.HLINE#
var proSleepTime#
var proContinueTimes#
var proTimes = 0

#攻击 平时 死亡
#var ifAoeHold = [false,false,false]#
var aoeModel = [0,0,0]#
var aoeRange = [0,0,0]#
var aoeTime = [0,0,0]#
var aoeTimes = [0,0,0]#
#自身状态数据
var nowEffect = [0,0,0,0,0,0]
var effValue = [0,0,0,0,0,0]#
var effTime = [0,0,0,0,0,0]#
var effTimes#
var effUncencal = [1,1,1,1,1]
var effDefence = [false,false,false,false,false,false]
var attackEffect = [0,0,0,0,0,0]#攻击给予状态同时表示好坏
var usuallyEffect#平时给予状态
var deathEffect#死亡给予状态

var ifFirstEffect = false#
var ifHealthEffect = false#
var healthEffValue = 0#
var ifDistanceEffect = false#

var shield = 0#
var oriSpeed = 0.6
var oriAniTime = 0.2
var attDefOrigin = [false,false,false]
var attDefence = attDefOrigin
var attDefShield#
var satDefValue = 0#
var attDefState#

func _init():
	pass
	
func _ready():
	
	pass
	
	
func firstSetting(soldier):
	soldierName[0] = soldier
	PictureAndCollBox(soldier)
	attDefence = attDefOrigin#记录攻击免疫
	healthUp = health#记录血量上限
	Global.FightSence.reloadSence.connect(reload)
	if attDefShield != null: attDefence = attDefShield
	#设置碰撞层
	collision_mask = Global.MAsk[camp+1][0]
	match type:
		Global.Type.PEOPLE: collision_layer = Global.LAyer[camp+1][0]
		Global.Type.TOWER: collision_layer = Global.LAyer[camp+1][2]
		Global.Type.SKILL:
			collision_layer = 0
			collision_mask = 0
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
	#if usuallyEffect != null: $usuallyTimer.start(Global.EffTime)
	#有开头效果的给予(速度攻击力都提升)
	#if ifFirstEffect == true:
		#damageAdd = Global.effect_calu(damageBasic,Global.Effect.ATTDAMAGE,null,null)
		#speedAdd = Global.effect_calu(speedBasic,Global.Effect.SPEED,null,null)
		#aniTimeCut = Global.effect_calu(aniTimeBasic,Global.Effect.SPEED,null,null)
		#walkAni = Ani.AWALK#控制开始效果时使用不同的动画
		#attack1Ani = Ani.AATTACK1
		#standardAni = walkAni
	#动画基础数据导入并开始播放动画
	#$Sprite2D.texture = load("res://assets/soldiers/%s.png" % [soldierName])
	MainValue()
	changeAnimation(standardAni,currentState)
	pass
	
func PictureAndCollBox(soldier):
	for STSDatename in Global.STSData[soldier]:
		set(STSDatename,Global.STSData[soldier][STSDatename])
		
	var spirte = SpriteFrames.new()#给动画播放器添加图片
	for i in aniName:
		spirte.add_animation(i)
		for j in animation[i]:
			var picture = load("res://assets/objects/%s/%s/%s%s.png"% [soldierName[0],i,i,j+1])
			spirte.add_frame(i,picture)
	$AnimatedSprite2D.sprite_frames = spirte
	#填充碰撞箱
	var newBox = RectangleShape2D.new()
	newBox.size = collBox
	$CollisionShape2D.shape = newBox
	
	pass
	

func _physics_process(_delta):#每帧执行的部分
	testchangeState()#状态切换检测
	#单体攻击时获得对方id 
	if currentState == State.ATTACK: 
		other = $Collision1.get_collider()
		#if ifFirstEffect == true:#解除开头效果并恢复动画
			#damageAdd = 0
			#speedAdd = 0
			#aniTimeCut = 0
			#walkAni = Ani.WALK
			#attack1Ani = Ani.ATTACK1
			#standardAni = walkAni
			#ifFirstEffect = false
	#血量低于临界攻击力提升
	#if health <= healthEffValue&&ifHealthEffect == true:
		#damageAdd = Global.effect_calu(damageBasic,Global.Effect.ATTDAMAGE,null,null)
		#ifHealthEffect = false
	#到一定距离内速度提升
	#if ifDistanceEffect == true:
		#speedAdd = Global.effect_calu(speedBasic,Global.Effect.SPEED,null,null)
		#aniTimeCut = Global.effect_calu(aniTimeBasic,Global.Effect.SPEED,null,null)
	#血量低于临界攻击免疫变少
	if shield <= 0&&attDefShield != null&&attDefence!=attDefOrigin:#盾坏免疫丢失
		attDefence = attDefOrigin
		PictureAndCollBox(soldierName[1])
		changeAnimation(currentAni,currentState)
	#不同状态攻击免疫改变
	#if attDefState != null:
		#if currentState == satDefValue: attDefence = attDefState 
		#else: attDefence = attDefOrigin
	#我方士兵控制，有开始状态的士兵处于开始状态时不能被控制
	MainValue()
	#移动控制
	position += speed*camp*speedDirection*speedState
	position.x = clamp(position.x,90,700)#限制移动范围
	
	#测试用
	$Label.text = str(health)
	if Input.is_action_just_pressed("ui_select"):
		if camp == Global.MONSTER: 
			print(speedEffect)
	pass

func MainValue():
	#基础数据实时更改
	damage = damageBasic+damageAdd+damageEffect
	speed = Vector2(speedBasic+speedAdd+speedEffect,0)
	aniTime = aniTimeBasic-aniTimeCut-aniTimeEffect
	attRange = Vector2(attRangeEffect+attRangeBasic,0)
	$Collision1.target_position = attRange*Vector2(camp,0)
	$Collision2.target_position = attRange*Vector2(camp,0)
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
		#第二碰撞,距离效果启用及停用,确保给距离效果是增值只赋值一次不是一直赋值
	#if $Collision2.is_colliding()&&Global.Coll2IfUse[collKind] == true:
		#if currentAni != Ani.ATTACK2&&collKind != Global.CollKind.NARESPE: 
			#changeState(Ani.ATTACK2,State.ATTACK)
		#if collKind == Global.CollKind.NARESPE&&ifDistanceEffect == false: ifDistanceEffect = true
	#else: 
		#if currentAni == Ani.ATTACK2&&collKind != Global.CollKind.NARESPE: 
			#changeState(standardAni,standardState)
		#if collKind == Global.CollKind.NARESPE: 
			#speedAdd = 0 
			#aniTimeCut = 0
			#ifDistanceEffect = false
	#第一第二同时碰撞
	#if $Collision1.is_colliding()&&$Collision2.is_colliding()&&collKind == Global.CollKind.SKYLAND:
		#if currentAni != Ani.ATTACK3: changeState(Ani.ATTACK3,State.ATTACK)
	#else: if currentAni == Ani.ATTACK3: changeState(standardAni,standardState)
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
	$AnimatedSprite2D.play(AniName,aniTime)
	#currentAnimationStart = animationStart[AniName]
	#frame = currentAnimationStart
	#currentAnimationEnd = animationEnd[AniName]
	#$Sprite2D.frame = animationStart[AniName]-seaAni
	#$animationTimer.start(aniTime)
	pass

#func TRvalue_caluORcreate(caluType,damager,target,projectile,proMode,proRange,ifAoeHold,aoeModel,aoeRange,attackType,damage,damagerType,giveEffect):

func attack():
	match damageMethod:
		Global.DamageMethod.NEARSINGLE:
			Global.TRvalue_caluORcreate(Global.Calu.ATTEFF,other,Global.TRtype.VALCALU,null,null,null,null,null,null,null,attackType,damage,damagerType,attackEffect,effValue,effTime,effTimes)
#func TRvalue_caluORcreate(caluType,damager,target,projectile,proMode,proRange,ifAoeHold,aoeModel,aoeRange,attackType,damage,damagerType,giveEffect,):
		Global.DamageMethod.NEARAOE:
			Global.TRvalue_caluORcreate(null,other,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],aoeTime[Global.AoeSet.ATTACK],aoeTimes[Global.AoeSet.ATTACK],attackType,damage,damagerType,attackEffect,effValue,effTime,effTimes)
			if soldierName[0] == "creeper": queue_free()
		Global.DamageMethod.FAR:
			var newPro = proSence.instantiate()
			add_child(newPro)
			newPro.position = Global.ProPos[projectile]
			Global.TRvalue_caluORcreate(null,null,newPro,projectile,proMode,attRange,aoeModel[Global.AoeSet.ATTACK],aoeRange[Global.AoeSet.ATTACK],aoeTime[Global.AoeSet.ATTACK],aoeTimes[Global.AoeSet.ATTACK],attackType,damage,damagerType,attackEffect,effValue,effTime,effTimes)
			newPro.firstSetting()
	pass

func _on_animationTimer_timeout():
	#frame+=1
	#if $Sprite2D.frame != currentAnimationEnd: $Sprite2D.frame += 1
	#if frame == currentAnimationEnd+1:
		#frame = currentAnimationStart
		#$Sprite2D.frame = currentAnimationStart
		#seaAni = 0#清空出入海的片段
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
				Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.DEATH],aoeRange[Global.AoeSet.DEATH],aoeTime[Global.AoeSet.DEATH],aoeTimes[Global.AoeSet.DEATH],null,null,null,deathEffect,effValue,effTime,effTimes)
			queue_free()
	pass


func attributeTimer(effName):
	match effName:
		Global.Effect.ATTDAMAGE:
			damageEffect = Global.effect_calu(damageBasic,effValue[effName],nowEffect[effName],effUncencal[effName])
		Global.Effect.SPEED:
			speedEffect =  Global.effect_calu(speedBasic,effValue[effName],nowEffect[effName],effUncencal[effName])
			aniTimeEffect = Global.effect_calu(aniTimeBasic,effValue[effName],nowEffect[effName],effUncencal[effName])
			changeAnimation(currentAni,currentState)
		Global.Effect.ATTRANGE:
			attRangeEffect = Global.effect_calu(attRangeBasic,effValue[effName],nowEffect[effName],effUncencal[effName])
	await get_tree().create_timer(effTime[effName],false).timeout
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
	
	
func holdDamageTimer(effName):
	$poisonTimer.start(effTime[effName]/effTimes)
	await get_tree().create_timer(effTime[effName],false).timeout
	$poisonTimer.stop()
	nowEffect[effName] = Global.OFFEFFECT
	effUncencal[effName] = Global.UNCENCAL
	pass
	
func _on_hold_damage_timer_timeout():
	health += Global.effect_calu(damageBasic,effValue[Global.Effect.HOLDDAMAGE],nowEffect[Global.Effect.HOLDDAMAGE],effUncencal[Global.Effect.HOLDDAMAGE])
	pass

func _on_usuallyTimer_timeout():
	if currentState != State.DEATH: Global.TRvalue_caluORcreate(null,self,Global.TRtype.VALCREATE,null,null,null,aoeModel[Global.AoeSet.NORMAL],aoeRange[Global.AoeSet.NORMAL],aoeTime[Global.AoeSet.NORMAL],aoeTimes[Global.AoeSet.NORMAL],null,null,null,usuallyEffect,effValue,effTime,effTimes)
	pass 


func reload():
	queue_free()
	pass 









