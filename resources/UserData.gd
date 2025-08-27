class_name UserData


static var mainVolume: float
static var musicVolume: float
static var sfxVolume: float

static var fileNames: Array[String]


static func save_user_data() -> void:
	var save_file = FileAccess.open("user://user.save", FileAccess.WRITE)
	
	save_file.store_float(mainVolume)
	save_file.store_float(musicVolume)
	save_file.store_float(sfxVolume)
	
	save_file.store_var(fileNames)


static func load_user_data() -> void:
	if not FileAccess.file_exists("user://user.save"):
		# We don't have a save to load.
		_default_data()
		return 
	
	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open("user://user.save", FileAccess.READ)
	if save_file.eof_reached():
		# there's no data to read
		_default_data()
		return
	
	mainVolume = save_file.get_float()
	musicVolume = save_file.get_float()
	sfxVolume = save_file.get_float()
	
	fileNames = save_file.get_var()


static func _default_data() -> void:
	mainVolume = 0.8
	musicVolume = 0.8
	sfxVolume = 0.6
