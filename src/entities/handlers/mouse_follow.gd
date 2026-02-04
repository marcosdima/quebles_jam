extends Handler
class_name MouseFollowHandler


var sensitivity: float = 0.1

var follow_z: bool = false
var follow_x: bool = false
var follow_y: bool = true


func validate_target(target: Entity = null) -> bool:
	return (
		super.validate_target(target)
		and target.mouse_module
		and target.movement
		and target.body_module
		and target.body_module.body
	)


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
	var pitch = -delta.y * sensitivity

	var body = _target.body_module.body
	var r = body.rotation

	if follow_y:
		r.y += deg_to_rad(yaw)

	if follow_x:
		r.x += deg_to_rad(pitch)

	if follow_z:
		r.z += deg_to_rad(yaw)

	_target.movement.set_rotation(r.y, r.x, r.z)
