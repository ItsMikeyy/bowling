extends Control

@onready var control_bar_sprite: AnimatedSprite2D = $AnimatedSprite2D

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_rest_animation()


func set_rest_animation() -> void:
	control_bar_sprite.animation = "rest"
	control_bar_sprite.play()

func set_active_animation() -> void:
	control_bar_sprite.animation = "active"
	control_bar_sprite.play()

func pause_active_animation() -> int:
	const DIRECTION_SPEED: float = 10.0
	control_bar_sprite.pause()
	var frame: int = control_bar_sprite.frame
	
	if frame == 0:
		return 0
	elif frame >= 1 and frame < 6:
		return -(DIRECTION_SPEED * frame)
	elif frame >= 6 and frame < 10:
		return -(11 - frame) * DIRECTION_SPEED
	elif frame >= 11 and frame < 16:
		return (frame - 10) * DIRECTION_SPEED
	else:
		return (20 - frame)
