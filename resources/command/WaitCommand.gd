class_name WaitCommand
extends Command


var duration: float


func _init(num: int, _duration: float) -> void:
	super._init(num)
	
	duration = _duration
