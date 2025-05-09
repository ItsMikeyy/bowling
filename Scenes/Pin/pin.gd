extends RigidBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	axis_lock_angular_x = true
	axis_lock_angular_y = true
	
func _on_body_entered(body: Node) -> void:
	if body is Ball:
		print("BALL")
		set_collision_mask_value(1, false)
		animation_player.play("hit")
