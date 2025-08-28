class_name ImportMenu
extends Control


signal return_selected()

const IMPORT_LIST_ITEM = preload("res://ui/components/import_list_item.tscn")

@onready var item_list_container: VBoxContainer = %VBoxContainer
@onready var file_dialog: FileDialog = $FileDialog
@onready var display_container: DisplayContainer = %DisplayContainer


func setup() -> void:
	# list images
	for texture in Assets.textures.keys():
		var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
		list_item.selected.connect(_handle_item_selected)
		item_list_container.add_child(list_item)
		list_item.setup(texture, ImportListItem.ImportType.IMAGE)
	
	# list audios
	for stream in Assets.streams.keys():
		var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
		list_item.selected.connect(_handle_item_selected)
		item_list_container.add_child(list_item)
		list_item.setup(stream, ImportListItem.ImportType.AUDIO)
	
	# list scripts
	for script in Assets.scripts.keys():
		var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
		list_item.selected.connect(_handle_item_selected)
		item_list_container.add_child(list_item)
		list_item.setup(script, ImportListItem.ImportType.SCRIPT)


func _on_btn_return_pressed():
	visible = false
	return_selected.emit()

func _on_btn_add_pressed() -> void:
	file_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	var parts: PackedStringArray = path.split(".")
	var extension: String = parts[parts.size()-1]
	
	match extension:
		"png":
			Assets.load_image(path)
		"wav", "mp3", "ogg":
			Assets.load_audio(path)
		"txt", "aug":
			Assets.load_script(path)


func _handle_item_selected(item_name: String, type: ImportListItem.ImportType) -> void:
	match type:
		ImportListItem.ImportType.IMAGE:
			display_container.display_texture(Assets.textures[item_name])
		ImportListItem.ImportType.AUDIO:
			display_container.display_audio(Assets.streams[item_name])
		ImportListItem.ImportType.SCRIPT:
			display_container.display_script(Assets.scripts[item_name])
