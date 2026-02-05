extends Handler
class_name Movement


# Signals emitted for animation/state handling in Character.
signal falling
signal landed
signal moving
signal idle


# Movement state constants
const FALLING_VAL = -0.1
const MOVING_THRESHOLD = 0.01

enum State { IDLE, MOVING, FALLING }
var _state = State.IDLE

var _can_move: bool = true
var speed: float = 5.0


func can_move() -> bool:
	return _can_move


func lock_movement() -> void: _can_move = false
func unlock_movement() -> void: _can_move = true


## Apply velocity to the body.
func set_velocity(velocity: Vector3) -> void:
	if not can_move():
		return
	_target.body.set_velocity(velocity)


## Apply horizontal movement respecting body type.
func apply_horizontal_movement(direction: Vector3, move_speed: float) -> void:
	if not can_move():
		return
	_target.body.apply_horizontal_movement(direction, move_speed)


## Apply gravity to kinematic bodies.
func apply_gravity(delta: float, gravity: float = 9.8) -> void:
	_target.body.apply_gravity(delta, gravity)


## Apply rotation to the body.
func rotation(yaw: float, pitch: float, roll: float) -> void:
	if not can_move():
		return
	_target.body.rotation(yaw, pitch, roll)


## Rotate the body towards a direction.
func rotate_towards(direction: Vector3, angular_speed: float, delta: float) -> void:
	if not can_move():
		return
	_target.body.rotate_towards(direction, angular_speed, delta)


## State getter.
func get_state() -> int:
	return _state


func _on_target_physics_frame(_delta: float) -> void:
	if entity.body_type == Body.BodyType.Static:
		return
	
	var vel = _target.body.get_velocity()
	var horizontal_speed = Vector3(vel.x, 0, vel.z).length()

	# Determine next state based on velocity.
	var next_state = State.IDLE
	if vel.y < FALLING_VAL:
		next_state = State.FALLING
	elif horizontal_speed > MOVING_THRESHOLD:
		next_state = State.MOVING
	else:
		next_state = State.IDLE

	# Emit a signal only when the state changes.
	if next_state != _state:
		match next_state:
			State.FALLING:
				falling.emit()
			State.MOVING:
				# If coming from FALLING, always go to IDLE first to emit "landed"
				if _state == State.FALLING:
					_state = State.IDLE
					landed.emit()
					return
				moving.emit()
			State.IDLE:
				if _state == State.FALLING:
					landed.emit()
				else:
					idle.emit()
		_state = next_state


func validate_target(target: Node3D) -> bool:
	if not super(target):
		return false

	## TODO: Error logs trigger invalidation.
	if not target.get('body'):
		log_error("Target entity lacks 'body' member required by Movement.")
		return false

	return true
