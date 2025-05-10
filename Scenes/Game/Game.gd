extends Node3D

const PIN = preload("res://Scenes/Pin/pin.tscn")
const BALL = preload("res://Scenes/Ball/ball.tscn")

@onready var timer: Timer = $Timer
@onready var pin_spawns: Node = $PinSpawns
@onready var ball_spawn: Marker3D = $BallSpawn

@export var max_shots = 2

var pins := {} #{ "pin_name": pin_instance }
var pin_spawns_dict := {} #{ "pin_name": spawn_node }
var score: int = 0
var timer_start: bool = false
var shot_count = 0



func _enter_tree() -> void:
	#Setup Signals
	SignalHandler.pin_knock.connect(_on_pin_knocked)
	SignalHandler.start_reset_timer.connect(_on_start_reset_timer)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	setup_pin_spawns()
	spawn_pins()
	spawn_ball()

func spawn_ball() -> void:
	#Create ball node and assign its position to BallSpawn 
	var ball := BALL.instantiate()
	ball.position = ball_spawn.position
	ball_spawn.add_child(ball)
	

func setup_pin_spawns() -> void:
	#Add all pin spawns to pin_spawns_dict
	var i := 0
	for marker in pin_spawns.get_children():
		var name := str(i)
		pin_spawns_dict[name] = marker
		i += 1


func spawn_pins() -> void:
	#Instantiate pins and add to pins dict
	#Set pin position to Pin(i)Spawn 
	var i := 0
	for marker in pin_spawns_dict.values():
		var pin := PIN.instantiate()
		var name := str(i)
		pin.name = name

		marker.add_child(pin)

		pins[name] = pin
		i += 1

#Update score on pin knock down
func _on_pin_knocked(name: String) -> void:
	score += 1

func remove_and_reset_pins() -> void:
	var to_remove := []

	for name in pins.keys():
		var pin = pins[name]
		
		#Remove the pin
		if pin.fallen:
			to_remove.append(name)
		#Reset standing pin
		else:
			var pin_spawn: Marker3D = pin_spawns_dict[name]

			pin.freeze = true

			var new_transform = pin.global_transform
			new_transform.origin = pin_spawn.global_transform.origin
			new_transform.basis = Basis() 
			pin.global_transform = new_transform

			pin.linear_velocity = Vector3.ZERO
			pin.angular_velocity = Vector3.ZERO

			pin.set_deferred("freeze", false)
	
	#Remove pins 
	for name in to_remove:
		if pins.has(name):
			pins[name].queue_free()
			pins.erase(name)

#Callen when ball enters killzone
func _on_start_reset_timer():
	timer.start()

	

func _on_timer_timeout() -> void:
	shot_count += 1
	if shot_count < max_shots:
		if score >= 10:
			print("STRIKE")
			return
		else:
			remove_and_reset_pins()
			spawn_ball()
	elif score >= 10:
		print("SPARE")
	else:
		print(score)
	
