extends Node3D
class_name Defaults


# Signal emitted each physics frame for handlers to hook into.
signal physics_frame(delta: float)

# Exports.
@export_group('Body', 'body_')
@export var body_type: Body.BodyType = Body.BodyType.Static


var body: Body
var keys: Keys
var mouse: MouseUse
var events: Events
var colors: Colors


func _init():
	body = Body.new(self)
	keys = Keys.new(self)
	mouse = MouseUse.new(self)
	events = Events.new(self)
	colors = Colors.new(self)


func _input(event: InputEvent) -> void:
	keys.process_input(event)
	mouse.process_input(event)


func _process(_delta: float) -> void:
	if keys:
		keys.emit_held_signal()


func _physics_process(delta: float) -> void:
	physics_frame.emit(delta)
