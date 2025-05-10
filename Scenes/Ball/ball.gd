extends CharacterBody2D
class_name Ball

var arrow: Sprite2D 

@onready var ball_sprite: Sprite2D = $BallSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedBall

@export var throw_speed: float = 400.0
@export var aim_speed: float = 0.05
@export var ball_texture: Texture2D

const SHRINK_RATE: float = 0.02 #TO CHANGE

var throw_angle: float = 0

var is_moving: bool = true
var is_aiming: bool = false 
var is_throwing: bool = false

func _ready() -> void:
	#Load ball sprite, set initial animation, get arrow node reference
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
	#Move ball side to side until SPACE is pressed
	if Input.is_action_just_pressed("CONFIRM"):
		velocity = Vector2.ZERO
		is_moving = false
		is_aiming = true
		animation_player.play("aim")

func aim_ball() -> void:
	#Move arrow side to side until SPACE is pressed
	if Input.is_action_just_pressed("CONFIRM"):
		animation_player.pause()
		throw_angle = arrow.rotation_degrees
		print("THROW")
		is_aiming = false
		is_throwing = true
		
		# Hide static sprite, show and animate the rolling sprite
		ball_sprite.visible = false
		animated_sprite.visible = true
		animated_sprite.play("Roll")  


func throw_ball(delta: float) -> void:
	velocity += Vector2(throw_angle * 5,-throw_speed) * delta #Need to fix * 5 but it works for now
	animated_sprite.scale -= Vector2(SHRINK_RATE, SHRINK_RATE) #For depth effect
	move_and_slide()
	
