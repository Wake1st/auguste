class_name SpeakCommand
extends Command


var name: String
var dialog: String
var duration: float


func _init(num: int, _name: String, _dialog: String, _delay: float, _duration: float) -> void:
	super._init(num, _delay)
	
	name = _name
	dialog = _dialog
	duration = _duration
