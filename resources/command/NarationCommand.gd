class_name NarationCommand
extends Command


var dialog: String
var duration: float
var wait: float


func _init(num: int, _dialog: String, _delay: float, _duration: float, _wait: float) -> void:
	super._init(num, _delay)
	
	dialog = _dialog
	duration = _duration
	wait = _wait
