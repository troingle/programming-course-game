extends StaticBody2D

@onready var player = $"../../Player"

func _process(delta):
	modulate = Global.palettes[player.currentPalette][1]
	
	if player.position.y < position.y - 30:
		$CollisionShape2D.disabled = false
	else:
		$CollisionShape2D.disabled = true
