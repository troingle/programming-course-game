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

@onready var spear = $Spear
@onready var spearSprite = $Spear/Sprite2D

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
	else:
		velocity.x = 0
	
	if is_on_floor() and Input.is_action_pressed("jump"):
		charging = true
		
	elif is_on_wall():
		position.x += 1
		print("WALL WALL WALL WALALLLLALLAL")
		anim.play("Walled")
		if Input.is_action_pressed("jump"):
			direction *= -1
			velocity.x *= -1
			velocity.y += JUMP_VELOCITY
			
	elif is_on_floor():
		anim.play("Idle")
	
	if Input.is_action_pressed("left") and x < 90:
		x += 3
	if Input.is_action_pressed("right") and x > -90:
		x -= 3
	
	if charging:
		if charge == 0:
			anim.play("Charge")
		charge += 2
		if !Input.is_action_pressed("jump") or charge >= 65:
			velocity = Vector2(0.0, charge * -15).rotated(deg_to_rad(-x))
			charging = false
			charge = 0
		
	spear.rotation = deg_to_rad(x)
		
	if !is_on_floor() and !is_on_wall():
		anim.play("Jump")
		
	if Input.is_action_pressed("reset"):
		position = start.position
		velocity.y = 0
		velocity.x = 0
		
	if Input.is_action_pressed("quit"):
		get_tree().quit()
		
	if roundf(position.x * 10) != roundf(currentX * 10):
		canWJ = true
		WJtimer = 0
		
		if currentX > position.x:
			anim.flip_h = false
		else:
			anim.flip_h = true
		
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
