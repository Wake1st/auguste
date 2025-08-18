class_name Command


var line_number: int
var delay: float

func _init(num: int, _delay: float = 0.0) -> void:
	line_number = num
	delay = _delay


func has_delay() -> bool:
	return delay > 0.0
