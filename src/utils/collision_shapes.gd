class_name CollisionShapes


static func box(size: Vector3 = Vector3.ONE) -> BoxShape3D:
	var shape = BoxShape3D.new()
	shape.size = size
	return shape


static func sphere(radius: float = 1.0) -> SphereShape3D:
	var shape = SphereShape3D.new()
	shape.radius = radius
	return shape


static func cylinder(radius: float = 1.0, height: float = 2.0) -> CylinderShape3D:
	var shape = CylinderShape3D.new()
	shape.radius = radius
	shape.height = height
	return shape


static func capsule(radius: float = 1.0, height: float = 2.0) -> CapsuleShape3D:
	var shape = CapsuleShape3D.new()
	shape.radius = radius
	shape.height = height
	return shape
