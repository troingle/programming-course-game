extends Camera2D

@onready var player = $"../Player"

func _process(delta):
	if player.position.y < position.y - 324:
		position.y -= 648
		if player.currentPalette == 5:
			player.currentPalette = -1
		player.currentPalette += 1
	if player.position.y > position.y + 324:
		position.y += 648
		if player.currentPalette == 5:
			player.currentPalette = -1
		player.currentPalette += 1
