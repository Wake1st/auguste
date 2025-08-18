class_name ScriptErrorButton
extends Button


signal selected(location: Vector2)

var error: EditorError

func create(e: EditorError) -> void:
	error = e
	text = e.message


func _on_pressed() -> void:
	selected.emit(error.location)
