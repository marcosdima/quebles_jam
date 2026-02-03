extends Handler
class_name WASDHandler


const DIRS = {
	"w": Vector3(0, 0, -1),
	"s": Vector3(0, 0, 1),
	"a": Vector3(1, 0, 0),
	"d": Vector3(-1, 0, 0),
}


var speed: float = 5.0
var _held: Dictionary = {}
var _direction: Vector3 = Vector3.ZERO
var angular_speed: float = 8.0


func validate_target(target: Entity = null) -> bool:
	return (
		super.validate_target(target)
		and target.body_module
		and target.body_module.body
		and target.keys_module
		and target.movement
	)


func _on_target_set():
	_target.keys_module.key_held.connect(_on_key_held)
	_target.keys_module.key_released.connect(_on_key_released)


func _on_target_physics_frame(_delta: float):
	var body = _get_body()
	if not body:
		return

	var movement_handler = _target.movement

	# Apply gravity through movement handler (handles CharacterBody3D)
	movement_handler.apply_gravity(_delta)

	# Transform local direction to global using target's Y rotation
	var direction = _direction
	if direction != Vector3.ZERO:
		var basis = body.global_transform.basis
		var forward = -basis.z.normalized()
		var right = basis.x.normalized()
		var move_dir = (forward * direction.z + right * direction.x).normalized()
		movement_handler.apply_horizontal_movement(move_dir, speed)
	else:
		# Stop horizontal movement when no input (for kinematic bodies)
		if body is CharacterBody3D:
			body.velocity.x = 0
			body.velocity.z = 0

	# For CharacterBody3D we still need to call move_and_slide
	if body is CharacterBody3D:
		body.move_and_slide()


func _on_key_held(custom: CustomKey):
	var name = _key_to_name(custom)

	if DIRS.has(name):
		_held[name] = true
		_update_direction()


func _on_key_released(custom: CustomKey):
	var name = _key_to_name(custom)

	if DIRS.has(name):
		_held.erase(name)
		_update_direction()


func _update_direction():
	var dir = Vector3.ZERO
	for key in _held:
		dir += DIRS[key]
	if dir.length() > 1.0:
		dir = dir.normalized()
	_direction = dir


func _get_body() -> CharacterBody3D:
	return _target.body_module.body as CharacterBody3D


func _key_to_name(key: CustomKey) -> String:
	var name = key.get_char().to_lower()
	if name.is_empty() and key.physical_keycode != 0:
		name = OS.get_keycode_string(key.physical_keycode).to_lower()
	return name
