extends Node2D

@onready var player = $"../../Player"
@onready var sprite = $AnimatedSprite2D
@onready var start = $"../../StartPos"

func _process(delta):
	if player.global_position.distance_to(position) < 50 and start.global_position != position:
		start.global_position = position
		
	if position == start.position:
		sprite.play("activated")
	else:
		sprite.play("default")
