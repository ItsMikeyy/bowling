extends Button

@export var hint: String = "A blue ball used for testing. I need to write more to see if the wrap around works properly"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	print(self.position)
	get_parent().show_tooltip(hint, self.position, self)

func _on_mouse_exited():
	get_parent().hide_tooltip()
	
	

#func set_up(texture: Texture2D, hint: String) -> void:
	#self.texture_normal = texture
	#hint_text = hint
