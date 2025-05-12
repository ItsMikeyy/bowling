extends Node2D

@export var strike_scene: PackedScene
@export var spare_scene: PackedScene
@export var blank_scene: PackedScene
@export var text_scene: PackedScene
@export var name_scene: PackedScene

var marks: Array[Node2D] = []
var current_total: int

'''
NEED TO UPDATE LOGIC FOR FRAME 10
'''

'''
Handles Strikes/Spares plus 2nd shot blanks
'''

func set_player_name(name: String, player_num: int): # Needs to be updated for multiple players when scoreboard is expanded.
	var marker = get_node_or_null("Name")
	if marker == null:
		push_warning("Name marker not found")
		return

	# Clear any existing instance first (optional)
	var existing = get_node_or_null("player_name_instance")
	if existing:
		existing.queue_free()

	var name_instance = text_scene.instantiate()
	name_instance.name = "player_name_instance"
	add_child(name_instance)  # Add first to ensure size is calculated

	# Set the scale before alignment
	var scale_factor = 2.25
	name_instance.scale = Vector2(scale_factor, scale_factor)  # Increase size by 50%

	var label_node = name_instance.get_node_or_null("Label")
	if label_node and label_node is Label:
		label_node.text = name
		label_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT  # Align left
		label_node.autowrap_mode = TextServer.AUTOWRAP_OFF

		# Ensure label has updated its size before positioning
		await get_tree().process_frame

		var label_size = label_node.get_minimum_size()

		# Position the bottom-left corner of the label at the marker position
		name_instance.position = Vector2(marker.position.x, marker.position.y - label_size.y/2 * scale_factor)
		
		name_instance.position.x += 10 * scale_factor
		name_instance.position.y -= 6
	else:
		push_warning("Label node not found or invalid in player name instance")
	

func mark_frame(frame_index: int, shot_num: int, frame_score: int, is_strike: bool, is_spare: bool) -> void:
	#print(">> mark_frame CALLED:", frame_index, shot_num, frame_score)
	
	var marker_name = null
	var instance_name = null
	var container = null
	
	if frame_index < 1 or frame_index > 13:
		push_warning("Invalid frame index: %d" % frame_index)
		return
	if shot_num < 1 or shot_num > 3:
		push_warning("Invalid frame index: %d" % shot_num)
		return
	
	if is_strike or is_spare:
		marker_name = "f%d" % frame_index
		container = $SymbolContainer
		instance_name = "f%d_instance_sym" % frame_index

	else:
		if shot_num == 1:
			marker_name = "f%d_1" % frame_index
			instance_name = "f%d_instance_1" % frame_index
			container = $MarkContainer1
		
		elif shot_num == 2:
			marker_name = "f%d" % frame_index
			instance_name = "f%d_instance_2" % frame_index
			container = $MarkContainerBox
		
		elif shot_num == 3:
			marker_name = "f%d" % frame_index
			instance_name = "f%d_instance_3" % frame_index
			container = $MarkContainerBox
	
	var marker = container.get_node_or_null(marker_name)
	
	if marker == null:
		push_warning("No marker found for %s" % marker_name)
		return
	
	if !is_strike and !is_spare:
		var existing_instance = container.get_node_or_null(instance_name)
		if existing_instance:
			var label_node = existing_instance.get_node_or_null("Label")
			if label_node and label_node is Label:
				configure_label(label_node, str(frame_score), false, marker.position, false)
			else:
				push_warning("Label node not found in existing instance: %s" % instance_name)
		else:
			var sym_name = "f%d_instance_sym" % frame_index
			var existing_sym = $SymbolContainer.get_node_or_null(sym_name)
			if existing_sym:
				existing_sym.visible = false
				if existing_sym in marks:
					marks.erase(existing_sym)
				$SymbolContainer.remove_child(existing_sym)
				#existing_sym.queue_free()
				
			var mark_instance = text_scene.instantiate()
			mark_instance.name = instance_name  
			mark_instance.position = marker.position

			var label_node = mark_instance.get_node_or_null("Label")
			
			if label_node and label_node is Label:
				configure_label(label_node, str(frame_score), false, marker.position, false)
			else:
				push_warning("Label node not found or invalid in new instance")

			container.add_child(mark_instance)
			marks.append(mark_instance)
	
	else:
		# Determine the correct label container and name based on shot_num
		var label_container: Node
		var label_instance_name: String

		if shot_num == 1:
			label_container = $MarkContainer1
			label_instance_name = "f%d_instance_1" % frame_index
		elif shot_num == 2:
			label_container = $MarkContainerBox
			label_instance_name = "f%d_instance_2" % frame_index
		elif shot_num == 3:
			label_container = $MarkContainerBox
			label_instance_name = "f%d_instance_3" % frame_index
		else:
			push_warning("Invalid shot_num for label removal")
			return

		var existing_label_instance = label_container.get_node_or_null(label_instance_name)
		if existing_label_instance:
			existing_label_instance.visible = false
			if existing_label_instance in marks:
				marks.erase(existing_label_instance)
			#existing_label_instance.queue_free()
			label_container.remove_child(existing_label_instance)
		
		var sym_name = "f%d_instance_sym" % frame_index
		var existing_sym = $SymbolContainer.get_node_or_null(sym_name)
		if existing_sym:
			existing_sym.visible = false
			if existing_sym in marks:
				marks.erase(existing_sym)
			$SymbolContainer.remove_child(existing_sym)

		# Now mark the symbol (strike/spare)
		var mark_instance = null
		if is_strike:
			mark_instance = strike_scene.instantiate()
		elif is_spare:
			mark_instance = spare_scene.instantiate()
		else:
			return

		mark_instance.name = "f%d_instance_sym" % frame_index
		mark_instance.position = marker.position
		$SymbolContainer.add_child(mark_instance)
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
			configure_label(label_node, str(current_total), frame_index == 10, marker.position, true)
		else:
			push_warning("Label node not found in existing instance: %s" % instance_name)
	else:
		var mark_instance = text_scene.instantiate()
		mark_instance.name = instance_name  # ✅ Assign unique name
		mark_instance.position = marker.position

		var label_node = mark_instance.get_node_or_null("Label")
		if label_node and label_node is Label:
			configure_label(label_node, str(current_total), frame_index == 10, marker.position, true)
		else:
			push_warning("Label node not found or invalid in new instance")

		$TotalContainer.add_child(mark_instance)
		marks.append(mark_instance)
	
	
func configure_label(label: Label, text: String, is_frame_ten: bool, marker_position: Vector2, is_total: bool) -> void:
	# Update scale of text to ensure it fits in scoreboard nicely
	
	scale_label_by_score_length(label, is_frame_ten, text, is_total)
	
	
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
	



func scale_label_by_score_length(label: Label, is_frame_10: bool, score: String, is_total: bool) -> void:
	var digit_count := str(score).length()
	var base_scale := 1.0
	
	# Adjust scaling based on number of digits
	if is_total:
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
	
	else:
		if digit_count == 2:
			base_scale = 0.75

	# Apply to the label's parent (Node2D), assuming it's the direct container
	var parent_node = label.get_parent()
	if parent_node and parent_node is Node2D:
		parent_node.scale = Vector2(base_scale, base_scale)


func get_max_width_text(digit_count: int) -> String:
	return "4".repeat(digit_count)
