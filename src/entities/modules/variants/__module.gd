class_name Module


var target: Modules = null


func _init(node: Modules) -> void:
	target = node

	# Connect to target's ready.
	target.ready.connect(_on_target_ready)
	target.physics_frame.connect(_on_target_physics_frame)
	

## Called when target node is ready. Must be overridden in subclass if needed.
func _on_target_ready() -> void:
	target.physics_frame.disconnect(_on_target_physics_frame)


## Called on each physics frame. Must be overridden in subclass if needed.
func _on_target_physics_frame(_delta: float) -> void:
	target.physics_frame.disconnect(_on_target_physics_frame)