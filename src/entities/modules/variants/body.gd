extends Module
class_name BodyModule


enum BodyType {
	Dynamic,
	Static,
	Kinematic,
}


signal body_setted()
signal shape_added(shape: Shape3D)


var body: Node3D
var shapes: Array[Shape3D] = []


## Sets up the physics body of the specified type.
func set_body(body_type: BodyType = BodyType.Static):
	# Remove existing body if any.
	if self.body and self.body.get_parent():
		self.body.get_parent().remove_child(self.body)

	# Create new body based on type.
	match body_type:
		BodyType.Dynamic:
			body = RigidBody3D.new()
			body.name = "DynamicBody"
		BodyType.Static:
			body = StaticBody3D.new()
			body.name = "StaticBody"
		BodyType.Kinematic:
			body = CharacterBody3D.new()
			body.name = "KinematicBody"

	# Add the body as a child.
	if body:
		target.add_child(body)


## Adds a collision shape instance to the current body.
func add_collision(shape: Shape3D) -> CollisionShape3D:
	# Create collision shape and add to body.
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = shape
	body.add_child(collision_shape)
	shapes.append(shape)

	# Emit signal.
	shape_added.emit(shape)

	return collision_shape
