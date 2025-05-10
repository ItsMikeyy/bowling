extends Control

@onready var item_container: HBoxContainer = $ItemContainer
@onready var tooltip_label: Label = $Hint

@export var shelf_item_scene: PackedScene





func _ready():
	tooltip_label.visible = false
	
	var shelf_items = [
	{
		"texture": preload("res://Assets/Sprites/ball1/ball.png"),
		"hint": "A blue ball."
	},
	]
	update_shelf(shelf_items)


func show_tooltip(text: String, position: Vector2) -> void:
	tooltip_label.text = text
	tooltip_label.global_position = position + Vector2(12, 12)  # Slight offset from cursor
	tooltip_label.visible = true


func hide_tooltip() -> void:
	tooltip_label.visible = false



func update_shelf(items: Array) -> void:
	clear_shelf()

	for item_data in items:
		var item = shelf_item_scene.instantiate()
		item.set_up(item_data["texture"], item_data["hint"])
		item_container.add_child(item)


# Removes all existing item nodes
func clear_shelf() -> void:
	for child in item_container.get_children():
		item_container.remove_child(child)
		child.queue_free()


func _on_mouse_entered():
	get_parent().get_parent().show_tooltip("My Tooltip", get_global_mouse_position())

func _on_mouse_exited():
	get_parent().get_parent().hide_tooltip()
