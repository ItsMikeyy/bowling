extends RigidBody2D

@onready var arrow: Sprite2D = $Arrow
@onready var ball_sprite: Sprite2D = $BallSprite

const BALL_SPEED: float = 400.0
const THROW_SPEED: float = 400.0
const ARROW_ROTATION_SPEED: float = 0.05
const SHRINK_RATE: float = 0.02 #TO CHANGE

var is_moving: bool = true
var is_aiming: bool = false 
var is_throwing: bool = false

func _physics_process(delta: float) -> void:
	if is_moving:
		move_ball()
	elif is_aiming:
		aim_ball()
	elif is_throwing:
		throw_ball()
		



func move_ball() -> void:
	var move_direction = Input.get_axis("LEFT", "RIGHT")
	linear_velocity = Vector2(BALL_SPEED * move_direction, 0.0)
	if Input.is_action_just_pressed("CONFIRM"):
		print("AIM")
		linear_velocity = Vector2.ZERO
		is_moving = false
		is_aiming = true

func aim_ball() -> void:
	var aim_direction = Input.get_axis("LEFT", "RIGHT")
	arrow.rotation_degrees += aim_direction
	arrow.rotation_degrees = clamp(arrow.rotation_degrees, -30, 30)
	print(arrow.rotation_degrees)

	if Input.is_action_just_pressed("CONFIRM"):
		print("THROW")
		is_aiming = false
		is_throwing = true

func throw_ball() -> void:
	linear_velocity = Vector2(0,-THROW_SPEED)
	ball_sprite.scale -= Vector2(SHRINK_RATE, SHRINK_RATE)		
	
