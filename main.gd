extends Node


@onready var camara: Camara3D = $Camara3D
@onready var ch: Character = $Character
@onready var floor_entity: Entity = $Floor


var aux_floor: Entity
var aux_entity: Entity = Entity.new()

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_set_auxiliar_entity()

	# Set floor.
	floor_entity.body.set_body(Body.BodyType.Static)
	floor_entity.body.add_collision(CollisionShapes.box(Vector3(10, 1, 10)))
	floor_entity.position = Vector3(0, 0, 0)

	# Camara follow character.
	camara.following = ch
	camara.follow(ch.root, Vector3(0, 1, 0))
	camara.look_at(ch.global_transform.origin + ch.global_transform.basis.z * 5, Vector3.UP)

	# Create a new floor entity with 'q'.
	ch.events.q_pressed.connect(
		func () -> void:
			aux_floor = floor_entity.duplicate() as Entity
			get_tree().current_scene.add_child(aux_floor)
			aux_floor.position = Vector3(randf_range(-5, 5), -1, randf_range(-5, 5))
	)


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _set_auxiliar_entity():
	# Create auxiliar entity.
	aux_entity = Entity.new()
	add_child(aux_entity)

	# Capture mouse.
	aux_entity.mouse.capture_mouse()
	aux_entity.events.escape_pressed.connect(aux_entity.mouse.release_mouse)
	aux_entity.mouse.button_pressed.connect(
		func(m: Mouse):
			if m.is_left_click():
				aux_entity.mouse.capture_mouse()
	)
