@tool
extends Test
class_name CamaraTest


var camera: Camara3D
var entities: Array = []


func set_test() -> void:
	var entity1 = Entity.new()
	entity1.name = "Rojo"
	entity1.position = Vector3(0, 0, -3)
	entity1.body_module.set_body(BodyModule.BodyType.Static)
	entity1.body_module.add_collision(CollisionShapes.box(Vector3(1, 2, 1)))
	entity1.colors.set_color(Color.RED)
	add_child(entity1)
	entities.append(entity1)

	var entity2 = Entity.new()
	entity2.name = "Azul"
	entity2.position = Vector3(0, 0, 3)
	entity2.body_module.set_body(BodyModule.BodyType.Static)
	entity2.body_module.add_collision(CollisionShapes.box(Vector3(1, 2, 1)))
	entity2.colors.set_color(Color.BLUE)
	entity2.rotation_degrees = Vector3(0, 180, 0)
	add_child(entity2)
	entities.append(entity2)

	if not camera:
		camera = Camara3D.new()
		add_child(camera)
	camera.current = true
	var cam_offset = Vector3(0, 7, -12)
	camera.follow(entities[0], cam_offset)
	camera.look_at(entities[0].position, Vector3.UP)
	
	DebugHandler.new(entity1)
	DebugHandler.new(entity2)

  
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_A:
				camera.follow(entities[0], Vector3(0, 7, -12))
				camera.look_at(entities[0].position, Vector3.UP)
			KEY_S:
				camera.follow(entities[1], Vector3(0, 7, -12))
				camera.look_at(entities[1].position, Vector3.UP)
			KEY_Q:
				camera.enable_mouse_follow()
