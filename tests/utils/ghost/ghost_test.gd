@tool
extends Test
class_name GhostTest


var ghost: Ghost
var floor_entity: Entity
var wasd: WASDHandler


func set_test() -> void:
	# Entity with WASD and collision
	body_module.set_body(BodyModule.BodyType.Dynamic)
	body_module.add_collision(CollisionShapes.box(Vector3(2, 2, 2)))
	wasd = WASDHandler.new(self)

	# Static floor
	floor_entity = Entity.new()
	add_child(floor_entity)
	floor_entity.position = Vector3(0, -3, 0)
	floor_entity.body_module.set_body(BodyModule.BodyType.Static)
	floor_entity.body_module.add_collision(CollisionShapes.box(Vector3(15, 1, 15)))

	# Ghost area ahead of the player
	ghost = Ghost.new()
	ghost.debug_mode = true
	ghost.position = Vector3(0, 0, -3)
	add_child(ghost)
	ghost.add_collision(CollisionShapes.box(Vector3(4, 4, 4)))

	ghost.entity_enter.connect(_on_entity_enter)
	ghost.entity_inside.connect(_on_entity_inside)
	ghost.entity_exit.connect(_on_entity_exit)
	ghost.rejected.connect(func(entity: Entity):
		print("rejected: ", entity.name)
	)

	# Apply test settings
	events.v_pressed.connect(_test_vip)
	events.b_pressed.connect(_test_filter)
	
	# Connect key events for group switching
	events.p_pressed.connect(func():
		self.group = Entity.Group.PLAYER
		print("Entity group changed to PLAYER")
	)
	events.o_pressed.connect(func():
		self.group = Entity.Group.DEFAULT
		print("Entity group changed to DEFAULT")
	)

func _on_entity_enter(entity: Entity) -> void:
	print("enter: ", entity.name)


func _on_entity_inside(entity: Entity) -> void:
	print("inside: ", entity.name)


func _on_entity_exit(entity: Entity) -> void:
	print("exit: ", entity.name)


## Test VIP groups: only Player entities pass
func _test_vip() -> void:
	ghost.vip_groups = [Entity.Group.PLAYER]
	print("Test: VIP groups set to [PLAYER]")


## Test filter groups: exclude certain groups
func _test_filter() -> void:
	ghost.vip_groups = []
	ghost.filter_groups = [Entity.Group.DEFAULT]
	print("Test: Filter groups set to [DEFAULT]")
