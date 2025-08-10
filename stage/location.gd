@tool
class_name Location
extends Node2D


signal finished()

@export_range(1,3) var layer: int:
	set(value):
		layer = value
		_update_layer(value)

@onready var spot_light: PointLight2D = $SpotLight
@onready var actor_node: Node2D = $ActorNode
@onready var light_timer: Timer = $LightTimer

var actors: Array[Actor]


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
	
	if command.shut_off:
		spot_light.enabled = false
	elif command.delay > 0:
		light_timer.start(command.delay)
	else:
		_turn_on()


func _ready() -> void:
	spot_light.enabled = false


func _update_layer(value: int) -> void:
	if has_node("SpotLight"):
		var spot: PointLight2D = get_node("SpotLight")
		spot.range_z_min = value
		spot.range_z_max = value
	
	if has_node("Sprite2D"):
		var spot: PointLight2D = get_node("Sprite2D")
		spot.z_index = value

func _move_actor(actor: Actor, duration: float, start: Vector2, target: Vector2) -> void:
	# reparent
	actor.reparent(actor_node)
	actor.global_position = start
	actors.push_back(actor)
	
	# move to location
	var tween = create_tween()
	tween.tween_property(actor, "global_position", target, duration)
	tween.tween_callback(_relocation_finished)

func _turn_on() -> void:
	spot_light.enabled = true
	finished.emit()

func _on_light_timer_timeout():
	_turn_on()

func _relocation_finished() -> void:
	finished.emit()
