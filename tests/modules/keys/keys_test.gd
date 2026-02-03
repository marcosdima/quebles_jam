@tool
extends Test
class_name KeysTest


func set_test() -> void:
	keys_module.key_pressed.connect(
		func(key: CustomKey):
			print("Char: ", key.get_char())
			print("Name: ", key.get_key_name())
			print("Shift pressed: ", key.shift_pressed)
	)
