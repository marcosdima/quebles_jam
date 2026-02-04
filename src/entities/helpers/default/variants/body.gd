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