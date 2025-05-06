extends CharacterBody2D
class_name Ball

var arrow: Sprite2D 

@onready var ball_sprite: Sprite2D = $BallSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var throw_speed: float = 400.0
@export var aim_speed: float = 0.05
@export var ball_texture: Texture2D
const SHRINK_RATE: float = 0.02 #TO CHANGE

var is_moving: bool = true
var is_aiming: bool = false 
var is_throwing: bool = false

func _ready() -> void:
	ball_sprite.texture = ball_texture
	animation_player.play("move")
	arrow = get_node("Arrow")

func _physics_process(delta: float) -> void:
	if is_moving:
		move_ball()
	elif is_aiming:
		aim_ball()
	elif is_throwing:
		throw_ball(delta)
	
		



func move_ball() -> void:
	if Input.is_action_just_pressed("CONFIRM"):
		print("AIM")
		velocity = Vector2.ZERO
		is_moving = false
		is_aiming = true
		animation_player.play("aim")

func aim_ball() -> void:
	if Input.is_action_just_pressed("CONFIRM"):
		print("THROW")
		is_aiming = false
		is_throwing = true
		animation_player.stop()


func throw_ball(delta: float) -> void:
	velocity += Vector2(0,-throw_speed) * delta
	ball_sprite.scale -= Vector2(SHRINK_RATE, SHRINK_RATE)
	move_and_slide()
	
