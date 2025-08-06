class_name MainMenu
extends Control


signal import_selected()


func _on_btn_import_pressed() -> void:
	import_selected.emit()
