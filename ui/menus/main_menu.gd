class_name MainMenu
extends Control


enum Options {
	IMPORT,
	SETTINGS,
	STAGE
}

signal option_selected(option: Options)


func _on_btn_import_pressed() -> void:
	option_selected.emit(Options.IMPORT)

func _on_btn_settings_pressed():
	option_selected.emit(Options.SETTINGS)

func _on_btn_stage_pressed():
	option_selected.emit(Options.STAGE)
