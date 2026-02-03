class_name CustomKey


var keycode: int
var physical_keycode: int
var unicode: int
var pressed: bool
var echo: bool
var shift_pressed: bool
var ctrl_pressed: bool
var alt_pressed: bool
var meta_pressed: bool


func _init(event: InputEventKey) -> void:
	keycode = event.keycode
	physical_keycode = event.physical_keycode
	unicode = event.unicode
	pressed = event.pressed
	echo = event.echo
	shift_pressed = event.shift_pressed
	ctrl_pressed = event.ctrl_pressed
	alt_pressed = event.alt_pressed
	meta_pressed = event.meta_pressed


## Gets the character as a string.
func get_char() -> String:
	# Prefer unicode when present, otherwise fall back to keycodes so letters still resolve.
	if unicode > 0:
		return char(unicode)

	if keycode != 0:
		return OS.get_keycode_string(keycode)

	if physical_keycode != 0:
		return OS.get_keycode_string(physical_keycode)

	return ""


## Gets the key name.
func get_key_name() -> String:
	return OS.get_keycode_string(keycode)
