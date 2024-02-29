extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -600.0

@onready var anim = get_node("AnimatedSprite2D")

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	anim.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		
	if Input.is_action_pressed("reset"):
		position.x = 0
		position.y = 0
		
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		anim.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		anim.play("Idle")

	move_and_slide()

