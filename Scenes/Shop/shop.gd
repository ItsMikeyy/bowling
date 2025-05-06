extends Control

@onready var currency_label: Label = $Currency

func _enter_tree() -> void:
	#connect update price signal for when user purchases
	SignalHandler.update_price.connect(_update_price)

func _ready() -> void:
	currency_label.text = "$" + str(ScoreManager.currency)
	
func _update_price() -> void:
	currency_label.text = "$" + str(ScoreManager.currency)
	
