class_name EditorError


var location: Vector2
var message: String


func _init(loc: Vector2, msg: String) -> void:
	location = loc
	message = msg
