extends Label

@onready var player = $"../../Player"

func _process(delta):
	modulate = Global.palettes[player.currentPalette][1]
