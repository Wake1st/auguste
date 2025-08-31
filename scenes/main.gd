class_name Main
extends Node


@onready var main_menu: MainMenu = $MainMenu
@onready var import_menu: ImportMenu = $ImportMenu
@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var ide: IDE = $IDE


func _ready() -> void:
	UserData.load_user_data()
	Assets.load_resources()
	
	settings_menu.setup()
	import_menu.setup()
	ide.setup()
	
	main_menu.option_selected.connect(_handle_option_selected)
	import_menu.return_selected.connect(_handle_return_selected)
	settings_menu.return_selected.connect(_handle_return_selected)
	ide.return_selected.connect(_handle_return_selected)


func _handle_option_selected(option: MainMenu.Options) -> void:
	match option:
		MainMenu.Options.IMPORT:
			import_menu.visible = true
		MainMenu.Options.SETTINGS:
			settings_menu.visible = true
		MainMenu.Options.IDE:
			ide.visible = true


func _handle_return_selected() -> void:
	main_menu.visible = true
