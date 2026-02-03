@tool
extends Test
class_name WasdTest


var obstacle_entity: Entity
var floor_entity: Entity
var wasd: WASDHandler


func set_test() -> void:
	print("HOLA")
	# Use Kinematic body for main entity
	body_module.set_body(BodyModule.BodyType.Kinematic)
	body_module.add_collision(CollisionShapes.capsule(0.5, 2.0))

	# Kinematic obstacle ahead to collide with (player can push it)
	obstacle_entity = Entity.new()
	add_child(obstacle_entity)
	obstacle_entity.position = Vector3(0, 0, -5)
	obstacle_entity.body_module.set_body(BodyModule.BodyType.Kinematic)
	obstacle_entity.body_module.add_collision(CollisionShapes.capsule(0.5, 2.0))

	# Static floor below
	floor_entity = Entity.new()
	add_child(floor_entity)
	floor_entity.position = Vector3(0, -3, 0)
	floor_entity.body_module.set_body(BodyModule.BodyType.Static)
	floor_entity.body_module.add_collision(CollisionShapes.box(Vector3(15, 1, 15)))

	# Create WASD handler on demand (no activation needed).
	wasd = WASDHandler.new(self)

	obstacle_entity.debug()
	floor_entity.debug()
	debug()
