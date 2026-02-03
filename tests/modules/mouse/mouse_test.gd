@tool
extends Test
class_name MouseTest


func set_test() -> void:
	mouse_module.button_pressed.connect(
		func(mouse: Mouse):
			print("Button: ", mouse.get_button_name())
			print("Position: ", mouse.position)
			print("Shift pressed: ", mouse.shift_pressed)
	)
	
	mouse_module.button_released.connect(
		func(mouse: Mouse):
			print("Button released: ", mouse.get_button_name())
	)
	
	mouse_module.mouse_moved.connect(
		func(mouse: Mouse):
			print("Mouse moved to: ", mouse.position)
	)
