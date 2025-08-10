class_name ActorCommand
extends Command


var name: String
var dialog: String


func _init(num: int, _name: String, _dialog: String = "") -> void:
	super._init(num)
	
	name = _name
	dialog = _dialog


func has_dialog() -> bool:
	return not dialog.is_empty()
