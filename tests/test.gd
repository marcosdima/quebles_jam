@tool
extends Entity
class_name Test


## TODO: Implement debug handler in old tests.


func _ready() -> void:
	if not Engine.is_editor_hint():
		set_test()


func set_test() -> void:
	pass
