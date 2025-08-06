class_name ImportMenu
extends Control


const IMPORT_LIST_ITEM = preload("res://ui/components/import_list_item.tscn")

@onready var item_list: VBoxContainer = %VBoxContainer
@onready var file_dialog: FileDialog = $FileDialog


func _on_btn_add_pressed() -> void:
	file_dialog.visible = true

func _on_file_dialog_file_selected(path: String) -> void:
	var parts: PackedStringArray = path.split(".")
	var extension: String = parts[parts.size()-1]
	
	match extension:
		"png":
			_load_image(path)
		"wav", "mp3", "ogg":
			_load_audio(path)
		"txt", "aug":
			_load_script(path)


func _load_image(path: String) -> void:
	# load texture
	var image: Image = Image.new()
	var err = image.load(path)
	if err != OK:
		return # Failed
	
	# save locally
	var file_name: String = path.get_file()
	var save_path: String = "res://images/%s" % file_name
	var error: int = image.save_png(save_path)
	if error != OK:
		print("Error saving image: ", error)
	
	# store in RAM
	var texture = ImageTexture.create_from_image(image)
	Assets.textures.set(file_name.split(".")[0], texture)
	
	# create list item
	var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
	item_list.add_child(list_item)
	list_item.setup(path.get_file(), ImportListItem.ImportType.IMAGE)


func _load_audio(path: String) -> void:
	# load texture
	var audio: AudioStream = load(path)
	
		# save locally
	var file_name: String = path.get_file().split(".")[0]
	var save_path: String = "res://audio/%s.wav" % file_name
	var error: int = (audio as AudioStreamWAV).save_to_wav(save_path)
	if error != OK:
		print("Error saving audio: ", error)
	
	# store in RAM
	Assets.streams.set(file_name, audio)
	
	# create list item
	var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
	item_list.add_child(list_item)
	list_item.setup(path.get_file(), ImportListItem.ImportType.AUDIO)


func _load_script(path: String) -> void:
	# load data
	var lines: PackedStringArray
	var file = FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached(): # iterate through all lines until the end of file is reached
		var line = file.get_pascal_string()
		lines.push_back(line)
	file.close()
	
		# save locally
	var file_name: String = path.get_file().split(".")[0]
	var save_path: String = "res://audio/%s.wav" % file_name
	var local_file = FileAccess.open(save_path, FileAccess.READ)
	for line in lines: # iterate through all lines until the end of file is reached
		local_file.store_pascal_string(line)
	local_file.close()
	
	# store in RAM
	var script: ScriptData = ScriptData.new(file_name, lines)
	Assets.scripts.set(file_name, script)
	
	# create list item
	var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
	item_list.add_child(list_item)
	list_item.setup(path.get_file(), ImportListItem.ImportType.SCRIPT)
