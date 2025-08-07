class_name ActorCommand
extends Command


var id: String
var dialog: String


func _init(num: int, _id: String, _dialog: String = "") -> void:
	super._init(num)
	
	id = _id
	dialog = _dialog


func has_dialog() -> bool:
	return not dialog.is_empty()
