extends Handler
class_name MouseFollowHandler


var sensitivity: float = 0.1


func _init(target: Entity, sens: float = 0.2) -> void:
    super(target)
    sensitivity = sens


func _on_target_set() -> void:
    _target.mouse_module.mouse_moved.connect(_process_mouse)


func _process_mouse(mouse):
    if not _target:
        return

    var delta = mouse.relative
    var yaw = -delta.x * sensitivity

    # If MovementHandler exists, use its rotation helpers (expects radians)
    if _target.movement:
        var current = _target.movement.get_rotation_y()
        _target.movement.set_rotation_y(current + deg_to_rad(yaw))
    else:
        # Fallback: adjust degrees directly
        if _target.body_module and _target.body_module.body:
            _target.body_module.body.rotation_degrees.y += yaw
        else:
            _target.rotation_degrees.y += yaw
