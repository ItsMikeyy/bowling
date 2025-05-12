extends Panel

@onready var label: Label = $TooltipLabel
@onready var select_button: TextureButton = $SelectButton

var item_data: Variant = null  # Store reference to the hovered item if needed

func show_tooltip(text: String, item_top_left: Vector2, item_size: Vector2, data: Variant = null) -> void:
	label.text = text
	item_data = data
	
	
	# Calculate the size of the tooltip
	var tooltip_size = self.size

	# Center the tooltip above the item
	#var x = item_top_left.x + (item_size.x / 2) - (tooltip_size.x / 2)
	#var y = item_top_left.y - tooltip_size.y - 10  # 10px offset above the item
	
	var x = (item_top_left.x - item_size.x)
	var y = item_top_left.y - item_size.y - tooltip_size.y

	global_position = Vector2(x, y)
	visible = true

func hide_tooltip() -> void:
	visible = false

func _ready():
	hide_tooltip()

func _on_select_button_pressed():
	if item_data != null:
		print("Selected item:", item_data)
		# Emit signal or call method if needed
	hide_tooltip()
