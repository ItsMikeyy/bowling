extends Control

@onready var power_bar_sprite: AnimatedSprite2D = $AnimatedSprite2D
var power: int = 0

	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_rest_animation()


func set_rest_animation() -> void:
	power_bar_sprite.animation = "rest"
	power_bar_sprite.play()

func set_active_animation() -> void:
	power_bar_sprite.animation = "active"
	power_bar_sprite.play()

func pause_active_animation() -> float:
	power_bar_sprite.pause()
	var frame : int = power_bar_sprite.frame + 1
	var mirrored_frame = 0
	if frame <= 12:
		mirrored_frame = frame 
	else: 
		mirrored_frame = 24 - frame  

	var speed := float(mirrored_frame * 50 + 300)
	print(mirrored_frame)
	return -speed
		
