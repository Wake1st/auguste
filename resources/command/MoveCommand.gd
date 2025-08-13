class_name MoveCommand
extends Command


var name: String
var location: Stage.Location
var duration: float


func _init(num: int, 
	_name: String, 
	_location: String, 
	_duration: float, 
) -> void:
	super._init(num)
	
	name = _name
	duration = _duration
	
	match _location.to_lower():
		"up-left":
			location = Stage.Location.UP_LEFT
		"up-center":
			location = Stage.Location.UP_CENTER
		"up-right":
			location = Stage.Location.UP_CENTER
		"left":
			location = Stage.Location.LEFT
		"center":
			location = Stage.Location.CENTER
		"right":
			location = Stage.Location.RIGHT
		"down-left":
			location = Stage.Location.DOWN_LEFT
		"down-center":
			location = Stage.Location.DOWN_CENTER
		"down-right":
			location = Stage.Location.DOWN_RIGHT
