class_name Main
extends Node


@onready var main_menu: MainMenu = $MainMenu
@onready var import_menu: ImportMenu = $ImportMenu


func _ready() -> void:
	main_menu.import_selected.connect(_handle_import_selected)

func _handle_import_selected() -> void:
	import_menu.visible = true
