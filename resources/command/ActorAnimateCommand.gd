class_name ActorAnimateCommand
extends ActorCommand


var animation: Stage.Animations
var duration: float
var cycle: float


func _init(
	num: int, 
	_name: String, 
	_animation: String, 
	_duration: float, 
	_cycle: float, 
	_dialog: String = ""
) -> void:
	super._init(num, _name, _dialog)
	
	match _animation:
		"bounce":
			animation = Stage.Animations.BOUNCE
		"wobble":
			animation = Stage.Animations.WOBBLE
		"rock":
			animation = Stage.Animations.ROCK
		"spin":
			animation = Stage.Animations.SPIN
	
	duration = _duration
	cycle = _cycle
