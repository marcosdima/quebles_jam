extends Module
class_name KeysModule


## Emitted when a key is pressed.
signal key_pressed(key: CustomKey)

## Emitted when a key is released.
signal key_released(key: CustomKey)

## Emitted when a key is held down.
signal key_held(key: CustomKey)


var _held_keys: Dictionary = {}


func _on_target_ready() -> void:
	super()
	target.set_process_input(true)
	target.set_process_unhandled_input(true)


## Processes input events. Call this from target's _input or _unhandled_input.
func process_input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key = CustomKey.new(event)
		if event.pressed and not event.echo:
			_on_key_pressed(key)
		elif not event.pressed:
			_on_key_released(key)


## Processes held keys. Call this from target's _process.
func emit_held_signal() -> void:
	for key in _held_keys.values():
		key_held.emit(key)


## Checks if a specific key is currently pressed.
func is_key_pressed(keycode: int) -> bool:
	return Input.is_key_pressed(keycode)


## Checks if a physical key is currently pressed.
func is_physical_key_pressed(keycode: int) -> bool:
	return Input.is_physical_key_pressed(keycode)


## Gets all currently held keys.
func get_held_keys() -> Array:
	return _held_keys.keys()


## Internal method called when a key is pressed.
func _on_key_pressed(key: CustomKey) -> void:
	if not _held_keys.has(key.keycode):
		_held_keys[key.keycode] = key
		key_pressed.emit(key)


## Internal method called when a key is released.
func _on_key_released(key: CustomKey) -> void:
	if _held_keys.has(key.keycode):
		_held_keys.erase(key.keycode)
		key_released.emit(key)
