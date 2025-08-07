class_name SoundCommand
extends Command


var name: String
var delay: String
var start: float
var duration: float
var count: float
var shouldStop: bool


func _init(
	num: int, _name: String, _delay: float = 0.0, _start: float = 0.0, _duration: float = -1.0, _count: float = 1.0, _shouldStop: bool = false
) -> void:
	super._init(num)
	
	name = _name
	delay = _delay
	start = _start
	duration = _duration
	count = _count
	shouldStop = _shouldStop
