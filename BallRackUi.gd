extends Control

#@onready var item_container: HBoxContainer = $ItemContainer
@onready var tooltip: Control = $Tooltip


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var roll_in_duration: float = 1.0


@export var shelf_item_scene: PackedScene



func _ready():
	tooltip.hide_tooltip()
	
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

func show_tooltip(text: String, position: Vector2, data: Variant = null) -> void:
	# Get the global position and size of the item (this can be passed as `position` and `data`)
	var item_global_position = position
	#print(item_global_position)
	var item_size = self.size
	print(item_size)
	tooltip.show_tooltip(text, item_global_position, item_size, data)


func hide_tooltip() -> void:
	tooltip.hide_tooltip()



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
	# Assuming "self" is the BallItem (Button) being hovered over
	var item_data = self  # 'self' is the BallItem Button, which contains the AnimatedSprite2D

	# Get the data we need: hint (description) and animation info from AnimatedSprite2D
	var hint = item_data.hint
	var animation_name = item_data.animated_sprite.animation  # This is the current animation name

	# Get the position and size of the button (BallItem) for the tooltip positioning
	var button_global_position = self.get_global_position()
	var button_size = self.size  # Get the size of the button

	# Now pass the data to show_tooltip()
	get_parent().get_parent().show_tooltip(hint, button_global_position, button_size, self)


func _on_mouse_exited():
	get_parent().get_parent().hide_tooltip()
