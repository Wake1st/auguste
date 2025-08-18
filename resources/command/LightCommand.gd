class_name LightCommand
extends Command


var type: Stage.Light
var location: Stage.Location
var color: Color
var shut_off: bool


func _init(
	num: int, 
	_type: String, 
	_location: String, 
	_color: Color, 
	_delay: float, 
	_shut_off: bool
) -> void:
	super._init(num, _delay)
	
	color = _color
	shut_off = _shut_off
	
	match _type.to_lower():
		"fresnel":
			type = Stage.Light.FRESNEL
		"spot":
			type = Stage.Light.SPOT
	
	match _location.to_lower():
		"up-left":
			location = Stage.Location.UP_LEFT
		"up-center":
			location = Stage.Location.UP_CENTER
		"up-right":
			location = Stage.Location.UP_RIGHT
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


func has_delay() -> bool:
	return delay > 0.0
