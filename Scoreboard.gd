extends Node2D

@export var strike_scene: PackedScene
@export var spare_scene: PackedScene
@export var blank_scene: PackedScene
@export var text_scene: PackedScene

var marks: Array[Node2D] = []

'''
NEED TO UPDATE LOGIC FOR FRAME 10
'''

'''
Handles Strikes/Spares plus 2nd shot blanks
'''
func mark_frame(frame_index: int, is_strike: bool, is_spare: bool, is_blank: bool) -> void:
	if frame_index < 1 or frame_index > 10:
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
	
	
