extends CharacterBody2D

var speed = 200.0
const NORMAL_SPEED = 200.0
const FLY_SPEED = 400.0
const JUMP_VELOCITY = -17.0

@onready var anim = get_node("AnimatedSprite2D")
@onready var head = get_node("Head")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var start = $"../StartPos"
@onready var win = $"../Win"
@onready var coin = $"../Coin"

var x = 0
var direction = 0
var canWJ = true
var WJtimer = 0
var currentX = 0

var charging = false
var charge = 0
var chargeX = 0

func _ready():
	Global.currentLvl = get_tree().current_scene.name.to_int()
	anim.flip_h = true

func _physics_process(delta):
	head.look_at(get_global_mouse_position())
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		charging = true
		
	elif is_on_wall():
		anim.play("Walled")
		if Input.is_action_pressed("jump"):
			direction *= -1
			velocity.x *= -1
			velocity.y += JUMP_VELOCITY
			
	elif is_on_floor():
		anim.play("Idle")
		
	if charging:
		if charge == 0:
			anim.play("Charge")
		charge += 1
		print(chargeX)
		if !Input.is_action_pressed("jump") or charge >= 70:
			velocity.y += charge * JUMP_VELOCITY
			velocity.x += chargeX * direction * FLY_SPEED
			charging = false
			charge = 0
			chargeX = 0
			
		if Input.is_action_pressed("left"):
			if chargeX > 0:
				chargeX = 0
			chargeX -= 100
		if Input.is_action_pressed("right"):
			if chargeX < 0:
				chargeX = 0
			chargeX += 100
			
		
	if !is_on_floor() and !is_on_wall():
		anim.play("Jump")
		
	if Input.is_action_pressed("reset"):
		position = start.position
		velocity.y = 0
		velocity.x = 0
		
	if Input.is_action_pressed("quit"):
		get_tree().quit()
		
	if is_on_floor():
		direction = Input.get_axis("left", "right")
		speed = NORMAL_SPEED
	else:
		speed = FLY_SPEED
	
	if direction and not charging and is_on_floor():
		velocity.x = direction * speed
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if direction > 0:
		anim.flip_h = true
	elif direction < 0:
		anim.flip_h = false
		
	if roundf(position.x * 10) != roundf(currentX * 10):
		canWJ = true
		WJtimer = 0
		currentX = position.x
		
	if not canWJ:
		WJtimer += 1
		if WJtimer >= 50:
			canWJ = true
			WJtimer = 0

	move_and_slide()
	
			
	if position.distance_to(win.position) <= 100:
		TransitionScreen.transition(delta)
		await TransitionScreen.on_transition_finished
		if get_tree():
			get_tree().change_scene_to_file("res://1.tscn")
	
	#if position.distance_to(coin.position) <= 50 and coin.visible == true:
		#coin.visible = false
		#play coin get sound
		#if get_tree().current_scene.name not in Global.coinedLevels:
			#Global.coinedLevels.append(get_tree().current_scene.name)
			#print(Global.coinedLevels)
		

func _on_area_2d_body_entered(body):
	if body.is_in_group("Spikes"):
		position = start.global_position
		velocity.x = 0
		velocity.y = 0
