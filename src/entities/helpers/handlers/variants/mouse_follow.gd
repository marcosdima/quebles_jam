extends Handler
class_name MouseFollowHandler


var sensitivity: float = 0.1

var follow_z: bool = false
var follow_x: bool = false
var follow_y: bool = true

# Optional clamping (disabled by default). Angles in degrees.
var clamp_x: bool = false
var clamp_x_min: float = -90.0
var clamp_x_max: float = 90.0

var clamp_y: bool = false
var clamp_y_min: float = -180.0
var clamp_y_max: float = 180.0


func _init(target: Entity, sens: float = 0.2) -> void:
	super(target)
	sensitivity = sens


func _on_target_set() -> void:
	_target.mouse.mouse_moved.connect(_process_mouse)

		
func _process_mouse(mouse):
	if not _target:
		return
		
	var delta = mouse.relative
	var yaw = -delta.x * sensitivity
	var pitch = -delta.y * sensitivity
	var body = _target.body.get_body()

	# Capture previous rotation for comparison.
	var prev = body.rotation
	var r = prev

	if follow_y:
		r.y += deg_to_rad(yaw)

	if follow_x:
		r.x -= deg_to_rad(pitch)

	if follow_z:
		r.z += deg_to_rad(yaw)

	# Apply optional clamping (convert degree bounds to radians)
	if clamp_x:
		var min_x = deg_to_rad(clamp_x_min)
		var max_x = deg_to_rad(clamp_x_max)
		r.x = clamp(r.x, min_x, max_x)

	if clamp_y:
		var min_y = deg_to_rad(clamp_y_min)
		var max_y = deg_to_rad(clamp_y_max)
		r.y = clamp(r.y, min_y, max_y)

	# Apply rotation via Body helper to keep single responsibility.
	_target.body.rotation(r.y, r.x, r.z)
