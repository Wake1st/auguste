class_name NewScriptWindow
extends Window


signal script_created(text: String)

@onready var text_edit: TextEdit = %TextEdit


func clear() -> void:
	text_edit.clear()


func _on_btn_cancel_pressed() -> void:
	close_requested.emit()


func _on_btn_confirm_pressed() -> void:
	script_created.emit(text_edit.text)
	close_requested.emit()
