extends RigidBody3D

class_name Ball

var power: Vector3 = Vector3(.0, 0.0,-900)

var has_shot: bool = false

func _physics_process(delta: float) -> void:
	if !has_shot:
		has_shot = true
		#apply_impulse(power * delta, position)
		linear_velocity = power * delta
