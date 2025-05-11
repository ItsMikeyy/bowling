extends Node2D

@export var strike_scene: PackedScene
@export var spare_scene: PackedScene
@export var blank_scene: PackedScene
@export var text_scene: PackedScene

var marks: Array[Node2D] = []
var current_total: int

'''
NEED TO UPDATE LOGIC FOR FRAME 10
'''

'''
Handles Strikes/Spares plus 2nd shot blanks
'''
func mark_frame(frame_index: int, is_strike: bool, is_spare: bool, is_blank: bool) -> void:
	if frame_index < 1 or frame_index > 12:
		push_warning("Invalid frame index: %d" % frame_index)
		return

	if !is_strike and !is_spare and !is_blank:
		return  # Nothing to mark

	var marker_name = "f%d" % frame_index
	var marker = $MarkContainer.get_node_or_null(marker_name)

	if marker == null:
		push_warning("No marker found for %s" % marker_name)
		return

	var mark_instance: Node2D

	if is_strike:
		mark_instance = strike_scene.instantiate()
	elif is_spare:
		mark_instance = spare_scene.instantiate()
	elif is_blank:
		mark_instance = blank_scene.instantiate()
	else:
		return

	mark_instance.position = marker.position
	$MarkContainer.add_child(mark_instance)
	marks.append(mark_instance)

func mark_frame_1(frame_index: int, frame_score: int) -> void:
	if frame_index < 1 or frame_index > 10:
		push_warning("Invalid frame index: %d" % frame_index)
		return
	
	var marker_name = "f%d_1" % frame_index
	var marker = $MarkContainer1.get_node_or_null(marker_name)
	
	if marker == null:
		push_warning("No marker found for %s" % marker_name)
		return

	var existing_label: Label = null

	for child in $MarkContainer1.get_children():
		if child.position == marker.position:
			var label_node = child.get_node_or_null("Label")
			if label_node and label_node is Label:
				existing_label = label_node
				break

	if existing_label:
		existing_label.text = str(frame_score)
		existing_label.visible = true
	else:
		var mark_instance = text_scene.instantiate()
		mark_instance.position = marker.position

		var label_node = mark_instance.get_node_or_null("Label")
		if label_node and label_node is Label:
			label_node.text = str(frame_score)
			label_node.visible = true
		else:
			push_warning("Label node not found or invalid in text_scene")

		$MarkContainer1.add_child(mark_instance)
		marks.append(mark_instance)
		
func mark_frame_total(frame_index: int, frame_score: int) -> void:
	current_total += frame_score
	if frame_index < 1 or frame_index > 10:
		push_warning("Invalid frame index: %d" % frame_index)
		return
	
	var marker_name = "t%d" % frame_index
	var instance_name = "t%d_instance" % frame_index
	var marker = $TotalContainer.get_node_or_null(marker_name)
	
	if marker == null:
		push_warning("No marker found for %s" % marker_name)
		return

	var existing_label: Label = null

	var existing_instance = $TotalContainer.get_node_or_null(instance_name)
	if existing_instance:
		var label_node = existing_instance.get_node_or_null("Label")
		if label_node and label_node is Label:
			configure_label(label_node, str(current_total), frame_index == 10, marker.position)
		else:
			push_warning("Label node not found in existing instance: %s" % instance_name)
	else:
		var mark_instance = text_scene.instantiate()
		mark_instance.name = instance_name  # ✅ Assign unique name
		mark_instance.position = marker.position

		var label_node = mark_instance.get_node_or_null("Label")
		if label_node and label_node is Label:
			configure_label(label_node, str(current_total), frame_index == 10, marker.position)
		else:
			push_warning("Label node not found or invalid in new instance")

		$TotalContainer.add_child(mark_instance)
		marks.append(mark_instance)
	
	
func configure_label(label: Label, text: String, is_frame_ten: bool, marker_position: Vector2) -> void:
	# Update scale of text to ensure it fits in scoreboard nicely
	scale_label_by_score_length(label, is_frame_ten)
	
	# Set label properties
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT  # Right align the text
	label.autowrap_mode = TextServer.AUTOWRAP_OFF
	
	# Measure the actual width of the label
	label.size = label.get_minimum_size()
	var actual_width = label.size.x  # Actual width of the label

	# Account for the scaling factor
	var scale_factor = label.get_parent().scale.x  # Assuming uniform scale (same for X and Y)
	var scaled_width = actual_width * scale_factor

	# Position the label so its right edge aligns with the marker position
	var parent_node = label.get_parent()
	if parent_node and parent_node is Node2D:
		# Adjust for scale by using the scaled width
		parent_node.position = Vector2(marker_position.x - scaled_width, marker_position.y)

	label.visible = true
	



func scale_label_by_score_length(label: Label, is_frame_10: bool) -> void:
	var digit_count := str(current_total).length()
	var base_scale := 1.0
	
	# Adjust scaling based on number of digits
	if is_frame_10:
		if digit_count >= 6:
				base_scale = 0.75
				if digit_count >= 8:
					base_scale = 0.66
				
	else: 
		match digit_count:
			1:
				base_scale = 1.0
			2:
				base_scale = 1.0
			3:
				base_scale = 1.0
			4:
				base_scale = 0.75 
			5: 
				base_scale = 0.66 
			6:
				base_scale = 0.50

	# Apply to the label's parent (Node2D), assuming it's the direct container
	var parent_node = label.get_parent()
	if parent_node and parent_node is Node2D:
		parent_node.scale = Vector2(base_scale, base_scale)


func get_max_width_text(digit_count: int) -> String:
	return "4".repeat(digit_count)
