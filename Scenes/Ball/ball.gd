extends RigidBody3D

class_name Ball


@export var power: Vector3 = Vector3(.0, 0.0,-500)
var has_thrown: bool = false

func _physics_process(delta: float) -> void:
	#throw ball
	if !has_thrown:
		has_thrown = true
		linear_velocity = power * delta
