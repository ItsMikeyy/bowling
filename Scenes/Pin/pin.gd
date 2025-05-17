extends RigidBody3D


var fallen = false
	
func _ready():
	axis_lock_angular_y = true

#Check if pin has fallen
func _on_knock_detection_body_entered(body: Node3D) -> void:
	if body.name == "Ground" and not fallen:
		fallen = true
		SignalHandler.pin_knock.emit(name)
		
