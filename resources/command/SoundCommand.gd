class_name SoundCommand
extends Command


var name: String
var delay: float
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
	super._init(num)
	
	name = _name
	delay = _delay
	start = _start
	duration = _duration
	cycle = _cycle
	volume = _volume
	shouldStop = _shouldStop
