class_name SoundCommand
extends Command


var name: String
var start: float
var duration: float
var cycle: float
var volume: float
var shouldStop: bool


func _init(
	num: int, 
	_name: String, 
	_delay: float = 0.0, 
	_start: float = 0.0, 
	_duration: float = -1.0, 
	_cycle: float = 1.0, 
	_volume: float = 0.0, 
	_shouldStop: bool = false,
) -> void:
	super._init(num, _delay)
	
	name = _name
	start = _start
	duration = _duration
	cycle = _cycle
	volume = _volume
	shouldStop = _shouldStop
