class_name Assets


static var textures: Dictionary[String, Texture2D]
static var streams: Dictionary[String, AudioStream]
static var scripts: Dictionary[String, ScriptData]



static func load_resources() -> void:
	var dir_path = "res://assets/images"
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() && not file_name.contains(".import"):
				_load_image(dir_path + "/" + file_name)
			
			file_name = dir.get_next()
	
	dir_path = "res://assets/audio"
	dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() && not file_name.contains(".import"):
				_load_audio(dir_path + "/" + file_name)
			
			file_name = dir.get_next()
	
	dir_path = "res://assets/scripts"
	dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() && not file_name.contains(".import"):
				_load_script(dir_path + "/" + file_name)
			
			file_name = dir.get_next()
			


static func _load_image(path: String) -> void:
	var texture: Texture2D = load(path)
	var file_name: String = path.get_file().split(".")[0]
	Assets.textures.set(file_name, texture)


static func _load_audio(path: String) -> void:
	var audio: AudioStream = load(path)
	var file_name: String = path.get_file().split(".")[0]
	Assets.streams.set(file_name, audio)


static func _load_script(path: String) -> void:
	# load data
	var lines: PackedStringArray
	var file = FileAccess.open(path, FileAccess.READ)
	while not file.eof_reached(): # iterate through all lines until the end of file is reached
		var line = file.get_line()
		lines.push_back(line)
	file.close()
	
	# store in RAM
	var file_name = path.get_file().split(".")[0]
	var script: ScriptData = ScriptData.new(file_name, lines.duplicate())
	Assets.scripts.set(file_name, script)
