class_name Trajectory


var _fn: Callable
var _accumulated: float = 0.0
var _acummulation_limit: float = INF
var _start_position: Vector3 = Vector3.ZERO


func _init(fn: Callable, start_magnitude: float = 0.0, start_position: Vector3 = Vector3.ZERO) -> void:
	_fn = fn
	_accumulated = start_magnitude
	_start_position = start_position


## Samples the trajectory accumulating the given magnitude delta.
func sample(delta_magnitude: float) -> Vector3:
	_accumulated += delta_magnitude

	if _accumulated > _acummulation_limit:
		_accumulated = _acummulation_limit
	
	return _start_position + _call(_accumulated)


## Peeks the trajectory at an absolute magnitude without accumulation.
func evaluate(magnitude: float) -> Vector3:
	return _start_position + _call(magnitude)


## Sets the start position for relative trajectory calculations.
func set_start_position(position: Vector3) -> void:
	_start_position = position


## Resets the accumulator.
func reset(magnitude: float = 0.0) -> void:
	_accumulated = magnitude


## Set a limit, after which the magnitude will not accumulate further.
func set_limit(limit: float) -> void:
	_acummulation_limit = limit


## Creates a linear trajectory along the given direction using magnitude as distance.
static func linear(direction: Vector3) -> Trajectory:
	var dir = direction.normalized()
	return Trajectory.new(
		func(m: float) -> Vector3:
			return dir * m
	)


func _call(magnitude: float) -> Vector3:
	if _fn.is_valid():
		return _fn.call(magnitude)
	return Vector3.ZERO
