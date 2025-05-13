extends RigidBody3D

class_name Ball

@onready var ball_sprite: AnimatedSprite3D = $AnimatedSprite3D

@export var power: Vector3 = Vector3(0.0, 0.0,-700)
const MOVE_SPEED: float =  300
var is_moving: bool = true
var is_aiming: bool = false
var is_charging: bool = false
var has_thrown: bool = false

func _ready() -> void:
	ball_sprite.animation = "rest"
	
func _physics_process(delta: float) -> void:
	
	if is_moving:
		move_ball(delta)
	elif is_aiming:
		aim_ball()
	elif is_charging:
		charge_ball()
	else:
		throw_ball(delta)
		


func move_ball(delta: float) -> void:
	var direction: float = Input.get_axis("LEFT", "RIGHT")
	linear_velocity = Vector3(direction * MOVE_SPEED, 0.0, 0.0) * delta
	if Input.is_action_just_pressed("CONFIRM"):
		is_moving = false
		is_aiming = true
		SignalHandler.set_control_active_animation.emit()
		
func aim_ball() -> void:
	if Input.is_action_just_pressed("CONFIRM"):
		is_aiming = false
		is_charging = true
		SignalHandler.pause_control_active_animation.emit()
		SignalHandler.set_power_active_animation.emit()

func charge_ball() -> void:
	if Input.is_action_just_pressed("CONFIRM"):
		is_charging = false
		has_thrown = true
		SignalHandler.pause_power_active_animation.emit()

func throw_ball(delta: float) -> void:
	linear_velocity = power * delta
	ball_sprite.animation = "throw"
	ball_sprite.play()
