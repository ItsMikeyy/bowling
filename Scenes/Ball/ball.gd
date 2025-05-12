extends RigidBody3D

class_name Ball

@export var power: Vector3 = Vector3(0.0, 0.0,-500)
const MOVE_SPEED: float =  300
var is_moving: bool = true
var has_thrown: bool = false

func _physics_process(delta: float) -> void:
	
	if is_moving:
		move_ball(delta)
	
	##throw ball
	if !has_thrown and Input.is_action_just_pressed("CONFIRM"):
		is_moving = false
		has_thrown = true
		linear_velocity = power * delta

func move_ball(delta: float) -> void:
	var direction: float = Input.get_axis("LEFT", "RIGHT")
	linear_velocity = Vector3(direction * MOVE_SPEED, 0.0, 0.0) * delta
	
