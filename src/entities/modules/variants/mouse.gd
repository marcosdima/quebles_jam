extends Module
class_name MouseModule


## Emitted when a mouse button is pressed.
signal button_pressed(mouse: Mouse)

## Emitted when a mouse button is released.
signal button_released(mouse: Mouse)

## Emitted when the mouse moves.
signal mouse_moved(mouse: Mouse)

## Emitted when the mouse is dragging (moving while button held).
signal mouse_dragged(mouse: Mouse)


var _held_buttons: Dictionary = {}
var _last_position: Vector2 = Vector2.ZERO


func _on_target_ready() -> void:
	target.set_process_input(true)
	target.set_process_unhandled_input(true)


## Processes input events. Call this from target's _input or _unhandled_input.
func process_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse = Mouse.new(event)
		if event.pressed:
			_on_button_pressed(mouse)
		else:
			_on_button_released(mouse)
	elif event is InputEventMouseMotion:
		var mouse = Mouse.new(event)
		_on_mouse_moved(mouse)
		
		# Check if dragging.
		if _held_buttons.size() > 0:
			mouse_dragged.emit(mouse)


## Gets the current mouse position.
func get_mouse_position() -> Vector2:
	return target.get_viewport().get_mouse_position()


## Checks if a specific mouse button is currently pressed.
func is_button_pressed(button: MouseButton) -> bool:
	return _held_buttons.has(button)


## Gets all currently held buttons.
func get_held_buttons() -> Array:
	return _held_buttons.keys()


## Capture mouse.
func capture_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


## Release mouse.
func release_mouse() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


## Internal method called when a button is pressed.
func _on_button_pressed(mouse: Mouse) -> void:
	if not _held_buttons.has(mouse.button):
		_held_buttons[mouse.button] = mouse
		button_pressed.emit(mouse)


## Internal method called when a button is released.
func _on_button_released(mouse: Mouse) -> void:
	if _held_buttons.has(mouse.button):
		_held_buttons.erase(mouse.button)
		button_released.emit(mouse)


## Internal method called when the mouse moves.
func _on_mouse_moved(mouse: Mouse) -> void:
	_last_position = mouse.position
	mouse_moved.emit(mouse)
