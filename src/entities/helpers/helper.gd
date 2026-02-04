extends Node3D
class_name Helper


var _error_log: Array = []
var _target: Node3D


func _init(target: Node3D):
	if validate_target(target):
		_target = target
		self._on_target_set()
		_target.physics_frame.connect(_on_target_physics_frame)
		_target.ready.connect(_on_target_ready)
	else:
		push_error(
            "Invalid target for Helper: %s \n errors: %s" % [str(self), str(_error_log)]
        )


## Logs an error message to the helper's error log.
func log_error(message: String) -> void:
	_error_log.append(message)


## Validates if the target entity is suitable for this helper.
func validate_target(target: Node3D) -> bool:
	return target != null


## Called when target node is set.
func _on_target_set() -> void:
	pass


## Called at physics frame.
func _on_target_physics_frame(_delta: float) -> void:
	pass


## Called when the target is ready.
func _on_target_ready() -> void:
	pass
