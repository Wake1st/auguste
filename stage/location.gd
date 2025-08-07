@tool
class_name Location
extends Node2D


signal finished()

@export_range(1,3) var layer: int:
	set(value):
		layer = value
		_update_layer(value)

@onready var actor_node: Node2D = $ActorNode

var actors: Array[Actor]


func pass_actor(actor: Actor, duration: float = 1.0) -> void:
	actors.push_back(actor)
	
	# reparent
	var glob_pos = actor.global_position
	actor.reparent(actor_node)
	actor.global_position = glob_pos
	
	# move to location
	var tween = create_tween()
	tween.tween_property(actor, "global_position", global_position, duration)
	tween.tween_callback(_relocation_finished)


func take_actor(nickname: String) -> Actor:
	for actor: Actor in actor_node.get_children():
		if actor.name == nickname:
			var index = actors.find(actor)
			actors.remove_at(index)
			return actor
	return null


func _update_layer(value: int) -> void:
	if has_node("SpotLight"):
		var spot: PointLight2D = get_node("SpotLight")
		spot.range_z_min = value
		spot.range_z_max = value
	
	if has_node("Sprite2D"):
		var spot: PointLight2D = get_node("Sprite2D")
		spot.z_index = value


func _relocation_finished() -> void:
	finished.emit()
