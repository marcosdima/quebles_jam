extends Default
class_name Body


enum BodyType {
	Dynamic,
	Static,
	Kinematic,
}


signal body_set()
signal shape_added(shape: Shape3D)


var _body: Node3D
var shapes: Array[Shape3D] = []


## Sets up the physics body of the specified type.
func set_body(body_type: BodyType = BodyType.Static):
	# Remove existing body if any.
	if self._body and self._body.get_parent():
		self._body.get_parent().remove_child(self._body)

	# Create new body based on type.
	match body_type:
		BodyType.Dynamic:
			_body = RigidBody3D.new()
			_body.name = "DynamicBody"
		BodyType.Static:
			_body = StaticBody3D.new()
			_body.name = "StaticBody"
		BodyType.Kinematic:
			_body = CharacterBody3D.new()
			_body.name = "KinematicBody"

	# Add the body as a child.
	if _body:
		_target.add_child(_body)


## Adds a collision shape instance to the current body.
func add_collision(shape: Shape3D) -> CollisionShape3D:
	# Create collision shape and add to body.
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = shape
	_body.add_child(collision_shape)
	shapes.append(shape)

	# Emit signal.
	shape_added.emit(shape)

	return collision_shape


## Appends a child node to the body.
func append_child(node: Node3D) -> void:
	if _body:
		_body.add_child(node)


## Get body.
func get_body() -> Node3D:
	return _body


func set_velocity(velocity: Vector3) -> void:
	if not _body:
		return
	elif _body is CharacterBody3D:
		_body.velocity = velocity
	elif _body is RigidBody3D:
		_body.linear_velocity = velocity


func get_velocity() -> Vector3:
	if not _body:
		return Vector3.ZERO
	if _body is CharacterBody3D:
		return _body.velocity
	elif _body is RigidBody3D:
		return _body.linear_velocity
	return Vector3.ZERO


func apply_horizontal_movement(direction: Vector3, move_speed: float) -> void:
	if not _body:
		return

	var flat = Vector3(direction.x, 0, direction.z)
	if flat == Vector3.ZERO:
		return

	flat = flat.normalized()
	if _body is CharacterBody3D:
		_body.velocity.x = flat.x * move_speed
		_body.velocity.z = flat.z * move_speed
	elif _body is RigidBody3D:
		var target_vel = flat * move_speed
		var current = Vector3(_body.linear_velocity.x, 0, _body.linear_velocity.z)
		var force = (target_vel - current) * _body.mass * 10.0
		_body.apply_central_force(force)


func apply_gravity(delta: float, gravity: float = 9.8) -> void:
	if not _body:
		return
	if _body is CharacterBody3D:
		_body.velocity.y -= gravity * delta


func rotation(yaw: float, pitch: float, roll: float) -> void:
	if not _body:
		return
	var r = _body.rotation
	r.y = yaw
	r.x = pitch
	r.z = roll
	_body.rotation = r


func get_body_rotation() -> Vector3:
	if not _body:
		return Vector3.ZERO
	return _body.rotation


func rotate_towards(direction: Vector3, angular_speed: float, delta: float) -> void:
	if not _body:
		return
	if direction.length() == 0:
		return

	var flat = Vector3(direction.x, 0, direction.z)
	if flat.length() == 0:
		return
	flat = flat.normalized()

	var target_yaw = atan2(flat.x, -flat.z)
	var current = _body.rotation.y
	var diff = wrapf(target_yaw - current, -PI, PI)
	var max_step = max(angular_speed, 0.0) * delta
	var step = clamp(diff, -max_step, max_step)
	var r = _body.rotation
	r.y = current + step
	_body.rotation = r