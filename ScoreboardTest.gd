extends Node2D
var tester : int = 0

func _ready():
	# Get the Scoreboard node (ensure it's named correctly in your scene tree)
	var scoreboard = $FrameSheetRoot/Scoreboard
	
	# Debug: Check if Scoreboard is accessible
	if scoreboard:
		print("Scoreboard found.")
		# Test strike in frame 1
		scoreboard.mark_frame(1, true, false, false)
		# Test spare in frame 2
		scoreboard.mark_frame(2, false, true, false)
		# Test score in frame 9
		
		print("Scoreboard found. Filling frames 1–9.")
		for i in range(1, 10):  # from 1 to 9
			scoreboard.mark_frame_1(i, i)
			scoreboard.mark_frame_total(i, i)
		
		scoreboard.mark_frame_total(10, 0)
	else:
		print("Scoreboard node not found!")

func _process(delta):
	
	if Input.is_action_pressed("TEST") and tester == 0:  
		var scoreboard = $FrameSheetRoot/Scoreboard
		if scoreboard and scoreboard.has_method("mark_frame"):
			scoreboard.mark_frame(4, true, false, false)  # Mark a strike for frame 4
			print("Frame 4 updated with a strike!")
			tester = 1
			scoreboard.mark_frame_1(1, 10)
			print("Frame 1 updated with a 0!")
			scoreboard.mark_frame_total(10, 1111)
	
	elif Input.is_action_pressed("TEST") and tester == 1: 
		var scoreboard = $FrameSheetRoot/Scoreboard
		if scoreboard and scoreboard.has_method("mark_frame"):
			scoreboard.mark_frame(3, false, true, false)  # Mark a strike for frame 4
			print("Frame 3 updated with a spare!")
			tester = 2
	elif Input.is_action_pressed("TEST") and tester == 2: 
		var scoreboard = $FrameSheetRoot/Scoreboard
		if scoreboard and scoreboard.has_method("mark_frame"):
			scoreboard.mark_frame(7, false, false, true)  # Mark a blank for frame 7
			print("Frame 7 updated with a blank!")
			tester = 0


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
