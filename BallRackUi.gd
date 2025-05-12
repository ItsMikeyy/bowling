extends Control

#@onready var item_container: HBoxContainer = $ItemContainer
@onready var tooltip_label: Label = $Hint


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var roll_in_duration: float = 1.0


@export var shelf_item_scene: PackedScene



func _ready():
	tooltip_label.visible = false
	
	var shelf_items = [
	{
		"texture": preload("res://Assets/Sprites/ball1/ball.png"),
		"hint": "A blue ball."
	},
	]
	#update_shelf(shelf_items)
	
func _input(event):
	if event.is_action_pressed("TEST"): 
		animation_player.play("test")

func show_tooltip(text: String, position: Vector2) -> void:
	tooltip_label.text = text
	tooltip_label.global_position = position + Vector2(12, 12)  # Slight offset from cursor
	tooltip_label.visible = true


func hide_tooltip() -> void:
	tooltip_label.visible = false



func update_shelf(items: Array) -> void:
	#clear_shelf()

	for i in range(items.size()):
		var item_data = items[i]
		var item = shelf_item_scene.instantiate()
		item.set_up(item_data["texture"], item_data["hint"])
		
		#item_container.add_child(item)
		


# Removes all existing item nodes
#func clear_shelf() -> void:
	#for child in item_container.get_children():
		#item_container.remove_child(child)
		#child.queue_free()


func _on_mouse_entered():
	get_parent().get_parent().show_tooltip("My Tooltip", get_global_mouse_position())

func _on_mouse_exited():
	get_parent().get_parent().hide_tooltip()
