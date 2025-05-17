extends RigidBody3D

class_name Ball

@onready var ball_sprite: AnimatedSprite3D = $AnimatedSprite3D

const MOVE_SPEED: float = 300.0
var is_moving: bool = true
var is_aiming: bool = false
var is_charging: bool = false
var has_thrown: bool = false

var control_bar: Node
var power_bar: Node
var power: float = 0
var horizontal_power: float = 0

func _ready() -> void:
	ball_sprite.animation = "rest"
	control_bar = get_node("../../UI/MainGameUI/MarginContainer/VBoxContainer/ControlBar")
	power_bar = get_node("../../UI/MainGameUI/MarginContainer/VBoxContainer/PowerBar")

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
	#Moving ball left/right with A/D or LEFT/RIGHT
	var direction: float = Input.get_axis("LEFT", "RIGHT")
	linear_velocity = Vector3(direction * MOVE_SPEED, 0.0, 0.0) * delta
	if Input.is_action_just_pressed("CONFIRM"):
		is_moving = false
		is_aiming = true
		control_bar.set_active_animation()
		
func aim_ball() -> void:
	#Aim ball with with control bar
	if Input.is_action_just_pressed("CONFIRM"):
		is_aiming = false
		is_charging = true
		horizontal_power = control_bar.pause_active_animation()
		print(horizontal_power)
		power_bar.set_active_animation()

func charge_ball() -> void:
	#charge shot with power bar
	if Input.is_action_just_pressed("CONFIRM"):
		is_charging = false
		has_thrown = true
		power = power_bar.pause_active_animation()
		power_bar.set_rest_animation()
		control_bar.set_rest_animation()
		
func throw_ball(delta: float) -> void:
	#launch ball 
	linear_velocity = Vector3(horizontal_power,0,power) * delta
	#ball_sprite.sprite_frames.set_animation_speed("throw-", )
	ball_sprite.animation = "throw"
	ball_sprite.play()
