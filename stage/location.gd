@tool
class_name Location
extends Node2D


signal finished()

@export_range(1,3) var layer: int:
	set(value):
		layer = value
		_update_layer(value)

@onready var character_node: Node2D = $CharacterNode

var characters: Array[Character]


func pass_character(character: Character, duration: float = 1.0) -> void:
	characters.push_back(character)
	
	# reparent
	var glob_pos = character.global_position
	character.reparent(character_node)
	character.global_position = glob_pos
	
	# move to location
	var tween = create_tween()
	tween.tween_property(character, "global_position", global_position, duration)
	tween.tween_callback(_relocation_finished)


func take_character(nickname: String) -> Character:
	for character: Character in character_node.get_children():
		if character.name == nickname:
			var index = characters.find(character)
			characters.remove_at(index)
			return character
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
