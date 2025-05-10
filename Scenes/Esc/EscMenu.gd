extends CanvasLayer

@onready var menu_box = $MenuBox
@onready var main_menu_button = $MenuBox/MainMenu

func _ready():
	visible = false
	center_menu()
	process_mode = Node.PROCESS_MODE_ALWAYS # works while paused
	
	#main_menu_button.connect(pressed(), _on_MainMenu_pressed())

func show_menu():
	print("Showing menu...")
	get_tree().paused = true
	visible = true

func hide_menu():
	print("Hiding menu...")
	get_tree().paused = false
	visible = false

func toggle_menu():
	if get_tree().paused:
		hide_menu()
	else:
		show_menu()
		
func center_menu():
	var screen_size = get_viewport().get_visible_rect().size
	var desired_size = screen_size * 0.75 # 75% of screen for now
	
	var position = Vector2(screen_size) - desired_size
	menu_box.position = position / 2
	menu_box.set_size(desired_size)
	resize_MM(desired_size)
	


	
		
func resize_MM(desired_size):
	# Resize and scale the button based on the desired size of the menu
	var button_size = Vector2(desired_size.x * 0.44, desired_size.y) 
	main_menu_button.set_size(button_size)  # Set the button's minimum size

	main_menu_button.position = Vector2(
		(desired_size.x - button_size.x) / 2,  # Center horizontally within the menu
		(desired_size.y - button_size.y) / 2 + desired_size.y*0.3   # Center vertically within the menu
		)

func _input(event):
	if event.is_action_pressed("ui_cancel"): 
		toggle_menu()

# Connected signals
	

func _on_Pins_Pressed():
	hide_menu()

func _on_QuitButton_Pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	print("Main Menu Pressed!")
	#hide_menu()
