extends Handler
class_name Debug


var debug_node: Node3D


func _on_target_set() -> void:
	# Set node.
	debug_node = Node3D.new()
	debug_node.name = "DebugNode"
	entity.add_child(debug_node)