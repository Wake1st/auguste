class_name ErrorDisplay
extends VBoxContainer


const SCRIPT_ERROR_BUTTON = preload("res://ui/editor/script_error_button.tscn")

var selection_callable: Callable


func setup(callable: Callable) -> void:
	selection_callable = callable


func clear_errors() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()


func add_error(e: EditorError) -> void:
	var button: ScriptErrorButton = SCRIPT_ERROR_BUTTON.instantiate()
	button.create(e)
	button.selected.connect(selection_callable)
	add_child(button)
