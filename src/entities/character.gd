@tool
extends Entity
class_name Character


@export var model: PackedScene = load("res://assets/models/xbot/xbot.tscn")


var wasd: WASDHandler
var model_instance: Node3D
var model_dimensions: Vector3


var mouse_follow: MouseFollowHandler
var movement: MovementHandler


# Movement variables.
const FALL_LAND_TIME = 3.45
const EPSILON = 0.1
var falling = false


func _ready() -> void:
	# Setup body as Kinematic (CharacterBody3D)
	body_module.set_body(BodyModule.BodyType.Kinematic)
	body_module.add_collision(CollisionShapes.capsule(0.5, 2.0))

	# Movement handler (emits signals). Character only maps signals to animations.
	movement = MovementHandler.new(self)
	movement.falling.connect(_on_falling)
	movement.moving.connect(_on_moving)
	movement.landed.connect(_on_landed)
	movement.idle.connect(_on_idle)

	# Set WASD handler.
	wasd = WASDHandler.new(self)
	
	# Add model.
	model_instance = model.instantiate()
	body_module.body.add_child(model_instance)

	# Calculate dimentions.
	var skeleton: Skeleton3D = model_instance.get_node('Armature').get_node('Skeleton3D')
	var combined: AABB
	var first := true

	for child in skeleton.get_children():
		if child is MeshInstance3D:
			var aabb = child.get_aabb() # local, sin rotación
			if first:
				combined = aabb
				first = false
			else:
				combined = combined.merge(aabb)

	# Modify postion based on dimentions.
	model_dimensions = combined.size
	model_instance.position.y = -model_dimensions.y / 2
	
	physics_frame.connect(_on_physics_frame)

	# Mouse follow.
	mouse_follow = MouseFollowHandler.new(self)


func play_animation(animation: String) -> void:
	var animation_player = get_animation_player()
	animation_player.play(animation)


func get_animation_player() -> AnimationPlayer:
	return model_instance.get_node("AnimationPlayer")


func _on_physics_frame(_delta):
	var anim = get_animation_player()
	
	# Handle falling animation looping, but only while MovementHandler still reports FALLING
	if movement and movement.get_state() == movement.State.FALLING:
		if anim.current_animation == "Falling" and anim.current_animation_position >= FALL_LAND_TIME:
			anim.seek(0.0, true)
	
	# Keep Walking animation looping while moving
	elif movement and movement.get_state() == movement.State.MOVING:
		if anim.current_animation != "Walking":
			anim.play("Walking")


func _play_if_needed(animation_name):
	var anim = get_animation_player()
	if anim.current_animation != animation_name:
		anim.play(animation_name)


# Signal handlers from MovementHandler
func _on_falling() -> void:
	movement.lock_movement()
	_play_if_needed("Falling")


func _on_moving() -> void:
	_play_if_needed("Walking")


func _on_landed() -> void:
	var anim = get_animation_player()
	anim.seek(FALL_LAND_TIME, true)
	anim.animation_finished.connect(func(_s): movement.unlock_movement())


func _on_idle() -> void:
	_play_if_needed("Idle")
