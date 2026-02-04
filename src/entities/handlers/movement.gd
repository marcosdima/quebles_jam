extends Handler
class_name MovementHandler


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


## Apply velocity to the body (works for CharacterBody3D and RigidBody3D)
func set_velocity(velocity: Vector3) -> void:
	if not can_move():
		return
	
	var body = _target.body_module.body
	if body is CharacterBody3D:
		body.velocity = velocity
	elif body is RigidBody3D:
		body.linear_velocity = velocity


## Apply horizontal movement respecting body type.
func apply_horizontal_movement(direction: Vector3, move_speed: float) -> void:
	# Locked movement.
	if not can_move():
		return

	var body = _target.body_module.body

	# Check if direction is zero.
	var flat = Vector3(direction.x, 0, direction.z)
	if flat == Vector3.ZERO:
		return

	# Normalize and apply movement.
	flat = flat.normalized()
	if body is CharacterBody3D:
		body.velocity.x = flat.x * move_speed
		body.velocity.z = flat.z * move_speed
	elif body is RigidBody3D:
		var target_vel = flat * move_speed
		var current = Vector3(body.linear_velocity.x, 0, body.linear_velocity.z)
		var force = (target_vel - current) * body.mass * 10.0
		body.apply_central_force(force)


## Apply gravity to kinematic bodies.
func apply_gravity(delta: float, gravity: float = 9.8) -> void:
	var body = _target.body_module.body
	if not body:
		return
	if body is CharacterBody3D:
		body.velocity.y -= gravity * delta


func get_velocity() -> Vector3:
	var body = _target.body_module.body
	if body is CharacterBody3D:
		return body.velocity
	elif body is RigidBody3D:
		return body.linear_velocity
	return Vector3.ZERO


## Rotation helpers
func set_rotation(yaw: float, pitch: float, roll: float) -> void:
	# Locked movement.
	if not can_move():
		return

	var body = _target.body_module.body
	var r = body.rotation
	r.y = yaw
	r.x = pitch
	r.z = roll
	body.rotation = r


func get_rotation_y() -> float:
	return _target.body_module.body.rotation.y


func rotate_towards(direction: Vector3, angular_speed: float, delta: float) -> void:
	# Smoothly rotate the body to face `direction` on the Y axis.
	if direction.length() == 0:
		return

	var body = _target.body_module.body
	var flat = Vector3(direction.x, 0, direction.z)

	if flat.length() == 0:
		return
	flat = flat.normalized()

	# target yaw: angle where forward (-Z) aligns with `flat`
	var target_yaw = atan2(flat.x, -flat.z)
	var current = body.rotation.y
	var diff = wrapf(target_yaw - current, -PI, PI)
	var max_step = angular_speed * delta
	var step = clamp(diff, -max_step, max_step)
	var r = body.rotation
	r.y = current + step
	body.rotation = r


func get_state() -> int:
	return _state


func validate_target(target: Entity = null) -> bool:
	return (
		super.validate_target(target)
		and target.body_module
		and target.body_module.body
	)


func _on_target_physics_frame(_delta: float) -> void:
	var body = _target.body_module.body
	var vel = body.velocity
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
