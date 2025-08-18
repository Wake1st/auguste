class_name SpeakCommand
extends Command


var name: String
var dialog: String
var duration: float
var wait: bool


func _init(
	num: int, 
	_name: String, 
	_dialog: String, 
	_delay: float, 
	_duration: float, 
	_wait: bool
) -> void:
	super._init(num, _delay)
	
	name = _name
	dialog = _dialog
	duration = _duration
	wait = _wait
