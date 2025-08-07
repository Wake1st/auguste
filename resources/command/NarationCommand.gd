class_name NarationCommand
extends Command


var dialog: String


func _init(num: int, _dialog: String) -> void:
	super._init(num)
	
	dialog = _dialog
