class_name ErrorCommand
extends Command


var error: String


func _init(num: int, text: String) -> void:
	super._init(num)
	
	error = "ERROR: %s" % text


func msg() -> String:
	return error
