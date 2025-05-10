extends Area3D



func _on_body_entered(body: Node3D) -> void:
	#Delete Ball
	if body is Ball:
		body.queue_free()
		SignalHandler.start_reset_timer.emit()
