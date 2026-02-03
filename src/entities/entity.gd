@tool
extends Modules
class_name Entity


enum Group {
	DEFAULT,
	PLAYER,
	ENEMY,
	ENVIRONMENT,
}


static var _count: Array[int] = [0]


var id: int
var group: Group = Group.DEFAULT
var db: DebugHandler


func _init() -> void:
	super()
	
	# Set id.
	id = _get_next_id() 
	name = "Entity_%d" % id


func set_group(new_group: Group) -> void:
	group = new_group


func _get_next_id() -> int:
	var next = _count.pop_front()
	if _count.size() == 0:
		_count.append(next + 1)
	return next


func _exit_tree() -> void:
	_count.push_front(id)


func debug() -> void:
	db = DebugHandler.new(self)
