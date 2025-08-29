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
				load_image(dir_path + "/" + file_name)
			
			file_name = dir.get_next()
	
	dir_path = "res://assets/audio"
	dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() && not file_name.contains(".import"):
				load_audio(dir_path + "/" + file_name)
			
			file_name = dir.get_next()
	
	dir_path = "res://assets/scripts"
	dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() && not file_name.contains(".import"):
				load_script(dir_path + "/" + file_name)
			
			file_name = dir.get_next()


static func load_image(path: String) -> void:
	var texture: Texture2D = load(path)
	var file_name: String = path.get_file().split(".")[0]
	textures.set(file_name, texture)


static func load_audio(path: String) -> void:
	var audio: AudioStream = load(path)
	var file_name: String = path.get_file().split(".")[0]
	streams.set(file_name, audio)


static func load_script(path: String) -> void:
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
	scripts.set(file_name, script)


static func save_script(script: ScriptData) -> void:
	var path = "res://assets/scripts/%s.txt" % script.name
	var file = FileAccess.open(path, FileAccess.WRITE)
	for line in script.lines: # store all lines into the file
		file.store_pascal_string(line)
	file.close()
	
	scripts[script.name] = script


static func create_script(filename: String) -> void:
	# ensure name is unique
	var unique_file = create_unique_name(filename)
	
	# load data
	var path = "res://assets/scripts/%s.txt" % unique_file
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.close()
	
	# store in RAM
	var script: ScriptData = ScriptData.new(unique_file, [])
	scripts.set(unique_file, script)


static func delete_script(filename: String) -> void:
	# remove from storage
	scripts.erase(filename)
	
	# deletes the file
	var dir = DirAccess.open("res://assets/scripts/")
	dir.remove("%s.txt" % filename)


static func has_script(filename: String) -> bool:
	var dir = DirAccess.open("res://assets/scripts/")
	return dir.file_exists("%s.txt" % filename)


static func create_unique_name(name: String) -> String:
	# ensure edited name is unique
	var unique_name = name
	var counter: int = 1
	while has_script(unique_name):
		unique_name = "%s(%s)" % [unique_name, counter]
		counter += 1
	
	return unique_name
