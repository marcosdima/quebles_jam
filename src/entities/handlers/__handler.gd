class_name Handler


var _target: Entity = null


func _init(target: Entity) -> void:
	if validate_target(target):
		_target = target
		self._on_target_set()
		_target.physics_frame.connect(_on_target_physics_frame)
	else:
		push_error("Invalid target for Handler: %s" % str(self))


## Validates if the target entity is suitable for this handler.
func validate_target(target: Entity = null) -> bool:
	return target != null


## Called when target node is set.
func _on_target_set() -> void:
	pass


## Called at physics frame.
func _on_target_physics_frame(_delta: float) -> void:
	pass
