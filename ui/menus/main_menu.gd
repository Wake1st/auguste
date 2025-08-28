class_name MainMenu
extends Control


enum Options {
	IMPORT,
	SETTINGS,
	IDE
}

signal option_selected(option: Options)


func _on_btn_import_pressed() -> void:
	visible = false
	option_selected.emit(Options.IMPORT)

func _on_btn_settings_pressed() -> void:
	visible = false
	option_selected.emit(Options.SETTINGS)

func _on_btn_ide_pressed():
	visible = false
	option_selected.emit(Options.IDE)
