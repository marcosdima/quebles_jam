@tool
extends Entity
class_name Character


var wasd: WASDHandler
var mouse_follow: MouseFollowHandler
var movement: Movement

# Root.
var root: Entity
var root_mouse_follow: MouseFollowHandler
var root_movement: Movement

# Movement variables.
const FALL_LAND_TIME = 3.45
const EPSILON = 0.1
var falling = false


func _ready():
	# Setup body as Kinematic (CharacterBody3D)
	body.set_body(Body.BodyType.Kinematic)
	body.add_collision(CollisionShapes.capsule(0.5, 2.0))

	# Set movment handler.
	movement = Movement.new(self)

	# Set WASD handler.
	wasd = WASDHandler.new(self)
	
	# Mouse follow.
	mouse_follow = MouseFollowHandler.new(self)

	_set_root()


func _set_root():
	# Set entity.
	root = Entity.new()
	root.body.set_body(Body.BodyType.Static)
	body.append_child(root)
	root.name = "Root"

	# Add movement for root so handlers can act on it.
	root_movement = Movement.new(root)

	# Follow mouse - handler will find both root.mouse and root.movement
	root_mouse_follow = MouseFollowHandler.new(root)
	root_mouse_follow.follow_y = false
	root_mouse_follow.follow_x = true
	root_mouse_follow.follow_z = false
	root_mouse_follow.clamp_x = true
	root_mouse_follow.clamp_x_min = -45.0
	root_mouse_follow.clamp_x_max = 45.0
