extends CharacterBody2D

var speed = 200.0
const NORMAL_SPEED = 200.0
const FLY_SPEED = 400.0

@onready var anim = get_node("AnimatedSprite2D")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var start = $"../StartPos"
@onready var coin = $"../Coin"

@onready var bg = $"../BG"
@onready var tilemap = $"../TileMap"

@onready var spear = $Spear
@onready var spearSprite = $Spear/Sprite2D

var x = 0

var canWJ = true
var WJtimer = 0
var currentX = 0

var charging = false
var charge = 0
var chargeX = 0

var oldVel = 0

var onIce = false

var currentPalette = 0

func _ready():
	Global.currentLvl = get_tree().current_scene.name.to_int()
	anim.flip_h = true

func _physics_process(delta):
	# MOVEMENT
	if is_on_wall() and not is_on_floor() and velocity.y > 0:
		velocity.y += gravity / 2.5 * delta
	elif not is_on_floor():
		velocity.y += gravity * delta
	elif not onIce:
		velocity.x = 0
		
	if velocity.x != 0:
		oldVel = velocity.x
		
	if is_on_floor() and Input.is_action_pressed("jump"):
		charging = true

	elif is_on_wall():
		anim.play("Walled")
		if Input.is_action_pressed("jump"):
			velocity.x = -oldVel * 0.8
			
		if anim.flip_h:
			velocity.x += 8
		else:
			velocity.x -= 8
			
	elif is_on_floor():
		anim.play("Idle")
		
	if position.y < -45:
		if Input.is_action_pressed("left") and x < 90:
			x += 3
		if Input.is_action_pressed("right") and x > -90:
			x -= 3
	else:
		x = 0
	
	if charging:
		if charge == 0:
			anim.play("Charge")
		if charge < 65:
			charge += 2
		if !Input.is_action_pressed("jump"):
			velocity = Vector2(0.0, charge * -13.5).rotated(deg_to_rad(-x))
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
		
	if Input.is_action_pressed("cancel"):
		charging = false
		charge = 0
		
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
	
	bg.color = Global.palettes[currentPalette][0]
	
	tilemap.set_layer_modulate(0, Global.palettes[currentPalette][1])
	$"../GrassMap".set_layer_modulate(0, Global.palettes[currentPalette][1])
	modulate = Global.palettes[currentPalette][1]
	$"../Labels/Label".add_theme_color_override("font_color", Global.palettes[currentPalette][1])
	
	if currentPalette == 5:
		currentPalette = -1
	if Global.epilepsyMode:
		currentPalette += 1
	
	#if position.distance_to(coin.position) <= 50 and coin.visible == true:
		#coin.visible = false
		#play coin get sound
		#if get_tree().current_scene.name not in Global.coinedLevels:
			#Global.coinedLevels.append(get_tree().current_scene.name)
			#print(Global.coinedLevels)
	
