class_name ActorExitCommand
extends ActorCommand


var location: Stage.Location
var direction: Stage.Direction = Stage.Direction.BELOW
var duration: float


func _init(num: int, _id: String, _location: String, _direction: String, _duration: float = 1.0, _dialog: String = "") -> void:
	super._init(num, _id, _dialog)
	
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
	
	match _direction.to_lower():
		"below":
			direction = Stage.Direction.BELOW
		"above":
			direction = Stage.Direction.ABOVE
		"left":
			direction = Stage.Direction.LEFT
		"right":
			direction = Stage.Direction.RIGHT
	
	duration = _duration
