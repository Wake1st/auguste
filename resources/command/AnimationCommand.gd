class_name AnimateCommand
extends Command


var name: String
var animation: Stage.Animations
var duration: float
var cycle: float


func _init(
	num: int, 
	_name: String, 
	_animation: String, 
	_duration: float, 
	_cycle: float, 
) -> void:
	super._init(num)
	
	name = _name
	duration = _duration
	cycle = _cycle
	
	match _animation:
		"bounce":
			animation = Stage.Animations.BOUNCE
		"wobble":
			animation = Stage.Animations.WOBBLE
		"rock":
			animation = Stage.Animations.ROCK
		"spin":
			animation = Stage.Animations.SPIN
