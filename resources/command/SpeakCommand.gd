class_name SpeakCommand
extends Command


var actor: String
var dialog: String
var delay: float
var duration: float


func _init(num: int, name: String, _dialog: String, _delay: float, _duration: float) -> void:
	super._init(num)
	
	actor = name
	dialog = _dialog
	delay = _delay
	duration = _duration
