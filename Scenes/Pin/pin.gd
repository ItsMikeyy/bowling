extends RigidBody2D

var is_knocked: bool = false
var base_position: Vector2
func _ready():
	base_position = global_position

func _physics_process(delta):
	if not is_knocked:
		# Option 1: Check tilt
		if abs(rotation_degrees) > 30:
			is_knocked = true
			print("Pin knocked (rotation)")

		# Option 2: Check if moved far from base
		elif (global_position - base_position).length() > 20:
			is_knocked = true
			print("Pin knocked (displaced)")
			set_collision_mask_value(2, true)
