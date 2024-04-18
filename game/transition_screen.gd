extends CanvasLayer

signal on_transition_finished

@onready var rect = $ColorRect
@onready var anim = $AnimationPlayer

func _ready():	
	rect.visible = false
	anim.animation_finished.connect(_on_animation_finished)
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_transition_finished.emit()
		anim.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		rect.visible = false

func transition(delta):
	rect.visible = true
	anim.play("fade_to_black")
	
