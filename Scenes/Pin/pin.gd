extends RigidBody3D

class_name Pin

var fallen = false

#Check if pin has fallen
func _on_knock_detection_body_entered(body: Node3D) -> void:
	if body.name == "Ground":
		fallen = true
		SignalHandler.pin_knock.emit(name)
		
