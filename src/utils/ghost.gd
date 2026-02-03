extends Area3D
class_name Ghost


signal entity_enter(entity: Entity)
signal entity_inside(entity: Entity)
signal entity_exit(entity: Entity)
signal rejected(entity: Entity)


var debug_mode: bool = false
var _inside: Dictionary = {}
var filter_groups: Array[Entity.Group] = []
var vip_groups: Array[Entity.Group] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	set_physics_process(true)


func add_collision(shape: Shape3D) -> CollisionShape3D:
	var collision_shape = CollisionShape3D.new()
	collision_shape.shape = shape
	add_child(collision_shape)
	return collision_shape


func _on_body_entered(body: Node) -> void:
	var entity = _find_entity(body)
	var reject_flag = (
		entity == null
		or _inside.has(entity)
		or (vip_groups.size() > 0 and not entity.group in vip_groups)
		or (entity.group in filter_groups)
	)

	if reject_flag:
		rejected.emit(entity)
		return
	
	_inside[entity] = true
	entity_enter.emit(entity)


func _on_body_exited(body: Node) -> void:
	var entity = _find_entity(body)
	if entity == null:
		return
	if not _inside.has(entity):
		return
	_inside.erase(entity)
	entity_exit.emit(entity)


func _physics_process(_delta: float) -> void:
	var to_remove: Array = []
	for entity in _inside.keys():
		if not is_instance_valid(entity):
			to_remove.append(entity)
			continue
		entity_inside.emit(entity)
	for entity in to_remove:
		_inside.erase(entity)
		entity_exit.emit(entity)


func _find_entity(node: Node) -> Entity:
	var current = node
	while current:
		if current is Entity:
			return current
		current = current.get_parent()
	return null
