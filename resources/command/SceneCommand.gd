class_name SceneCommand
extends Command


var name: String


func _init(num: int, _name: String) -> void:
	super._init(num)
	
	name = _name
