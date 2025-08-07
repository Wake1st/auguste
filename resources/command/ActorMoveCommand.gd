class_name ActorMoveCommand
extends ActorCommand


var location: Stage.Location
var duration: float


func _init(num: int, _id: String, _location: String, _duration: float = 1.0, _dialog: String = "") -> void:
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
	
	duration = _duration
