extends Node2D

func _ready():
	# Get the Scoreboard node (ensure it's named correctly in your scene tree)
	var scoreboard = $FrameSheetRoot/Scoreboard
	
	# Debug: Check if Scoreboard is accessible
	if scoreboard:
		print("Scoreboard found.")
		scoreboard.set_player_name("TESTING", 1)
		
		print("Scoreboard found. Filling frames 1–9.")
		for i in range(1,11):
			scoreboard.mark_frame(i, 1, i, false, false)
			scoreboard.mark_frame(i, 2, i, false, false)
		scoreboard.mark_frame(11, 2, 1, false, true)
		scoreboard.mark_frame(12, 3, 1, true, false)
	else:
		print("Scoreboard node not found!")

func _process(delta):
	
	if Input.is_action_pressed("TEST") :  
		var scoreboard = $FrameSheetRoot/Scoreboard
		if scoreboard and scoreboard.has_method("mark_frame"):
			scoreboard.mark_frame_total(10, 1111)
			scoreboard.mark_frame(11, 2, 10, false, false)
			scoreboard.mark_frame(12, 3, 10, false, false)
	
	if Input.is_action_pressed("TEST1") :  
		var scoreboard = $FrameSheetRoot/Scoreboard
		if scoreboard and scoreboard.has_method("mark_frame"):
			scoreboard.mark_frame(11, 2, 1, true, false)
	
	if Input.is_action_pressed("TEST2") :  
		var scoreboard = $FrameSheetRoot/Scoreboard
		if scoreboard and scoreboard.has_method("mark_frame"):
			scoreboard.mark_frame(12, 3, 1, false, true)
			

# Testing funciton used to find widest number in font for smoother updating
func find_widest_digit(font: Font) -> void:
	var widest_char = ""
	var max_width = 0
	var array = ['00', '44', '99']
	for digit in array:
		var width = font.get_string_size(digit).x
		print("Digit: ", digit, " Width: ", width)
		if width > max_width:
			max_width = width
			widest_char = digit

	print("Widest digit is: ", widest_char, " with width: ", max_width)
