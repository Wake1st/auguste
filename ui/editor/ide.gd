class_name IDE
extends Control


const SCRIPT_ERROR_BUTTON = preload("res://ui/editor/script_error_button.tscn")

@onready var text_editor: TextEditor = %TextEditor
@onready var error_container: VBoxContainer = %VBoxContainer


func create_error(e: EditorError) -> void:
	var button: ScriptErrorButton = SCRIPT_ERROR_BUTTON.instantiate()
	button.create(e)
	button.selected.connect(text_editor.set_caret)
	error_container.add_child(button)
