@tool
extends Test
class_name CharacterTest


@onready var camara: Camara3D = $Camara3D
@onready var ch: Character = $Character


var fl: Entity
var fl2: Entity
var wasd: WASDHandler


func set_test():
	# Set floor.
	_set_fl()
	
	# Camara follow character.
	camara.following = ch
	camara.follow(ch, Vector3(0, 2, -4))
	camara.look_at(ch.global_transform.origin, Vector3.UP)

	ch.mouse_module.capture_mouse()
	ch.events.escape_pressed.connect(ch.mouse_module.release_mouse)
	

func _set_fl():
	fl = Entity.new()
	self.add_child(fl)
	fl.body_module.set_body(BodyModule.BodyType.Static)
	fl.body_module.add_collision(CollisionShapes.box(Vector3(10, 1, 10)))
	fl.position = Vector3(0, 0, 0)

	fl2 = Entity.new()
	self.add_child(fl2)
	fl2.body_module.set_body(BodyModule.BodyType.Static)
	fl2.body_module.add_collision(CollisionShapes.box(Vector3(10, 1, 10)))
	fl2.position = Vector3(0, -10, -10)
