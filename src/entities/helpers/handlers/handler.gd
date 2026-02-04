extends Helper
class_name Handler


var entity: Entity


func _init(target: Node3D):
    super(target)
    entity = target as Entity


func validate_target(target: Node3D) -> bool:
    if not super(target):
        return false

    if not (target is Entity):
        log_error("Handler can only be assigned to Entity nodes.")
        return false
    
    return true