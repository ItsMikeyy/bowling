extends TextureButton

@export var hint_text: String = "Default tooltip"

func _ready():
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)

func _on_mouse_entered():
	get_parent().get_parent().show_tooltip(hint_text, get_global_mouse_position())

func _on_mouse_exited():
	get_parent().get_parent().hide_tooltip()

func set_up(texture: Texture2D, hint: String) -> void:
	self.texture_normal = texture
	hint_text = hint
