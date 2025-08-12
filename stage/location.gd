@tool
class_name Location
extends Marker2D


signal finished()

@export_range(1,3) var layer: int:
	set(value):
		layer = value
		_update_layer(value)

@onready var spot_light: PointLight2D = $SpotLight
@onready var actor_node: Node2D = $ActorNode
@onready var light_timer: Timer = $LightTimer

var actors: Array[Actor]
var isTurningOff: bool


func send_actor(actor: Actor, duration: float = 1.0) -> void:
	_move_actor(actor, duration, actor.global_position, global_position)


func enter_actor(actor: Actor, duration: float, out_position: Vector2) -> void:
	_move_actor(actor, duration, out_position, global_position)


func exit_actor(actor: Actor, duration: float, out_position: Vector2) -> void:
	_move_actor(actor, duration, global_position, out_position)


func take_actor(nickname: String) -> Actor:
	for actor: Actor in actor_node.get_children():
		if actor.name == nickname:
			var index = actors.find(actor)
			actors.remove_at(index)
			return actor
	return null


func toggle_light(command: LightCommand) -> void:
	spot_light.color = command.color
	isTurningOff = command.shut_off
	
	if command.shut_off:
		_turn_off()
	elif command.delay > 0:
		light_timer.start(command.delay)
	else:
		_turn_on()


func _ready() -> void:
	_update_layer(layer)
	spot_light.enabled = false


func _update_layer(value: int) -> void:
	if has_node("SpotLight"):
		var spot: PointLight2D = get_node("SpotLight")
		spot.range_z_min = value
		spot.range_z_max = value

func _move_actor(actor: Actor, duration: float, start: Vector2, target: Vector2) -> void:
	# reparent
	actor.reparent(actor_node)
	actor.global_position = start
	actor.z_index = layer
	actors.push_back(actor)
	
	# move to location
	var tween = create_tween()
	tween.tween_property(actor, "global_position", target, duration)
	tween.tween_callback(_relocation_finished)

func _turn_on() -> void:
	spot_light.enabled = true
	finished.emit()

func _turn_off() -> void:
	spot_light.enabled = false
	finished.emit()

func _on_light_timer_timeout() -> void:
	if isTurningOff:
		_turn_off()
	else:
		_turn_on()

func _relocation_finished() -> void:
	finished.emit()
