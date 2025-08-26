class_name BreakpointExit
extends Node


signal continued()


func _input(event) -> void:
	if event.is_action_pressed("continue_execution"):
		continued.emit()
