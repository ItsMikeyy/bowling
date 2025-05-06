extends Control


@onready var price_label: Label = $Frame/Price

@export var price: float = 0

func _ready() -> void:
	price_label.text = "$"  + str(price)

func _on_gui_input(event: InputEvent) -> void:
	#Checks for mouse LEFT click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		#Check if users currency is > price before purchase
		if ScoreManager.currency > price:
			ScoreManager.currency -= price	
			print("Purchase: ", price_label.text)
			#Emit update price to change user currency text in shop
			SignalHandler.update_price.emit()
		else:
			print("Invalid: ", price_label.text)
