extends Node3D
class_name Modules


# Signal emitted each physics frame for handlers to hook into.
signal physics_frame(delta: float)

# Exports.
@export_group('Body', 'body_')
@export var body_type: BodyModule.BodyType = BodyModule.BodyType.Static


# Modules.
var body_module: BodyModule
var keys_module: KeysModule
var mouse_module: MouseModule
var events: EventsModule
var colors: ColorsModule


func _init() -> void:
	# Initialize modules.
	body_module = BodyModule.new(self)
	keys_module = KeysModule.new(self)
	mouse_module = MouseModule.new(self)
	events = EventsModule.new(self) # TODO: rename variables without _module.
	colors = ColorsModule.new(self)

func _input(event: InputEvent) -> void:
	keys_module.process_input(event)
	mouse_module.process_input(event)


func _process(_delta: float) -> void:
	keys_module.emit_held_signal()


func _physics_process(delta: float) -> void:
	physics_frame.emit(delta)
