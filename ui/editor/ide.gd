class_name IDE
extends Control


@onready var text_editor: TextEditor = %TextEditor
@onready var error_display: ErrorDisplay = %ErrorDisplay


func _ready() -> void:
	error_display.setup(text_editor.set_caret)


func _input(event) -> void:
	if event.is_action_pressed("save"):
		# get all lines
		var lines = text_editor.get_lines()
		
		# process lines, return errors
		var errors: Array[EditorError] = ErrorChecker.process(
			ScriptData.new("EMPTY", lines)
		)
		
		# clears errors
		error_display.clear_errors()
		
		# display error
		for error in errors:
			error_display.add_error(error)
