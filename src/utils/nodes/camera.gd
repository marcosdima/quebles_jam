
@tool
extends Camera3D
class_name Camara3D


# --- Entity follow stack ---
var following: Entity = null
var follow_offset: Vector3 = Vector3.ZERO


func follow(
	target: Entity,
	offset: Vector3 = Vector3.ZERO,
) -> void:
	var parent = get_parent()
	if parent:
		parent.remove_child(self)
	following = target
	follow_offset = offset
	following.body_module.body.add_child(self)
	position = follow_offset


func unfollow() -> void:
	following.remove_child(self)
	following = null
	follow_offset = Vector3.ZERO


func set_orientation(
	new_rotation: Vector3,
	new_rotation_degrees: Vector3,
	look_at_point: Vector3,
	up: Vector3 = Vector3.UP
) -> void:
	if new_rotation != null:
		rotation = new_rotation
	elif new_rotation_degrees != null:
		rotation_degrees = new_rotation_degrees
	elif look_at_point != null:
		look_at(look_at_point, up)
	
