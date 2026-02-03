@tool
extends Test
class_name EventsTest


func set_test() -> void:
	# Print generic string signals.
	events.w_pressed.connect(func():
		print("W key pressed signal received")
	)
	events.w_released.connect(func():
		print("W key released signal received")
	)
	events.w_held.connect(func():
		print("W key held signal received")
	)
	
	events.space_pressed.connect(func():
		print("Space key pressed signal received")
	)
	events.space_released.connect(func():
		print("Space key released signal received")
	)
	events.space_held.connect(func():
		print("Space key held signal received")	
	)
