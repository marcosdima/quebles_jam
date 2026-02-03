@tool
extends Test
class_name BodyTest


func set_test() -> void:
	body_module.set_body(BodyModule.BodyType.Dynamic)
	assert(body_module.body.name == "DynamicBody", "Body should be DynamicBody after setting to Dynamic.")

	body_module.set_body(BodyModule.BodyType.Kinematic)
	assert(body_module.body.name == "KinematicBody", "Body should be KinematicBody after setting to Kinematic.")
	
	var box_shape = body_module.add_collision(CollisionShapes.box(Vector3(2, 2, 2)))
	assert(box_shape.shape is BoxShape3D, "Added shape should be a BoxShape3D.")
	assert((box_shape.shape as BoxShape3D).size == Vector3(2, 2, 2), "BoxShape3D size should be correct.")
	
	var sphere_shape = body_module.add_collision(CollisionShapes.sphere(1.5))
	assert(sphere_shape.shape is SphereShape3D, "Added shape should be a SphereShape3D.")
	assert((sphere_shape.shape as SphereShape3D).radius == 1.5, "SphereShape3D radius should be correct.")
	
	var cylinder_shape = body_module.add_collision(CollisionShapes.cylinder(1.0, 3.0))
	assert(cylinder_shape.shape is CylinderShape3D, "Added shape should be a CylinderShape3D.")
	assert((cylinder_shape.shape as CylinderShape3D).radius == 1.0, "CylinderShape3D radius should be correct.")
	assert((cylinder_shape.shape as CylinderShape3D).height == 3.0, "CylinderShape3D height should be correct.")
	
	var capsule_shape = body_module.add_collision(CollisionShapes.capsule(0.5, 2.0))
	assert(capsule_shape.shape is CapsuleShape3D, "Added shape should be a CapsuleShape3D.")
	assert((capsule_shape.shape as CapsuleShape3D).radius == 0.5, "CapsuleShape3D radius should be correct.")
	assert((capsule_shape.shape as CapsuleShape3D).height == 2.0, "CapsuleShape3D height should be correct.")

	body_module.add_collision(CollisionShapes.box(Vector3(5, 5, 2)))
