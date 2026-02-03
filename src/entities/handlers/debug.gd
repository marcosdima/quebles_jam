extends Handler
class_name DebugHandler


var show: bool = true:
	set(value):
		show = value
		if debug_node:
			debug_node.visible = value
var debug_node: Node3D


func _on_target_set() -> void:
	# Set node.
	debug_node = Node3D.new()
	debug_node.name = "DebugNode"
	debug_node.visible = show
	_target.add_child(debug_node)