class_name Mouse


var button: MouseButton
var pressed: bool
var position: Vector2
var global_position: Vector2
var relative: Vector2
var velocity: Vector2
var double_click: bool
var shift_pressed: bool
var ctrl_pressed: bool
var alt_pressed: bool
var meta_pressed: bool


func _init(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		button = event.button_index
		pressed = event.pressed
		position = event.position
		global_position = event.global_position
		double_click = event.double_click
		shift_pressed = event.shift_pressed
		ctrl_pressed = event.ctrl_pressed
		alt_pressed = event.alt_pressed
		meta_pressed = event.meta_pressed
		relative = Vector2.ZERO
		velocity = Vector2.ZERO
	elif event is InputEventMouseMotion:
		button = MOUSE_BUTTON_NONE
		pressed = false
		position = event.position
		global_position = event.global_position
		relative = event.relative
		velocity = event.velocity
		double_click = false
		shift_pressed = event.shift_pressed
		ctrl_pressed = event.ctrl_pressed
		alt_pressed = event.alt_pressed
		meta_pressed = event.meta_pressed


## Checks if this is a left click.
func is_left_click() -> bool:
	return button == MOUSE_BUTTON_LEFT


## Checks if this is a right click.
func is_right_click() -> bool:
	return button == MOUSE_BUTTON_RIGHT


## Checks if this is a middle click.
func is_middle_click() -> bool:
	return button == MOUSE_BUTTON_MIDDLE


## Checks if this is a scroll wheel event.
func is_scroll() -> bool:
	return button == MOUSE_BUTTON_WHEEL_UP or button == MOUSE_BUTTON_WHEEL_DOWN


## Gets the button name.
func get_button_name() -> String:
	match button:
		MOUSE_BUTTON_LEFT: return "Left"
		MOUSE_BUTTON_RIGHT: return "Right"
		MOUSE_BUTTON_MIDDLE: return "Middle"
		MOUSE_BUTTON_WHEEL_UP: return "Wheel Up"
		MOUSE_BUTTON_WHEEL_DOWN: return "Wheel Down"
		_: return "None"
