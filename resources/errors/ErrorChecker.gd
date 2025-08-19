class_name ErrorChecker


enum Types {
	ACTION_NOT_RECOGNISED,
	PARAM_NOT_RECOGNISED,
	ACTOR_NOT_RECOGNISED,
	TEXTURE_NOT_RECOGNISED,
	SOUND_NOT_RECOGNISED,
	ANIMATION_NOT_RECOGNISED,
	LOCATION_NOT_RECOGNISED,
	DIRECTION_NOT_RECOGNISED,
	INVALID_NUMBER,
	STRING_NOT_FOUND,
	STRING_NOT_CLOSED,
	STRING_EMPTY,
	NEEDLESS_PARAMS,
}

static var messages: Dictionary[Types, String] = {
	Types.ACTION_NOT_RECOGNISED: "'%s' is not an action.",
	Types.PARAM_NOT_RECOGNISED: "'%s' is not a param for '%s'.",
	Types.ACTOR_NOT_RECOGNISED: "Cannot find actor '%s'.",
	Types.TEXTURE_NOT_RECOGNISED: "Cannot find texture '%s'.",
	Types.SOUND_NOT_RECOGNISED: "Cannot find sound '%s'.",
	Types.ANIMATION_NOT_RECOGNISED: "'%s' is not an animation.",
	Types.LOCATION_NOT_RECOGNISED: "'%s' is not a location.",
	Types.DIRECTION_NOT_RECOGNISED: "'%s' is not a direction.",
	Types.INVALID_NUMBER: "'%s' is not a valid number.",
	Types.STRING_NOT_FOUND: "A string using %s quotes should be here.",
	Types.STRING_NOT_CLOSED: "String must be closed with a matching %s symbol.",
	Types.STRING_EMPTY: "Strings cannot be empty.",
	Types.NEEDLESS_PARAMS: "These params mean nothing and should be removed: %s"
}

static var suggestions: Array[String] = [
	"-Check the spelling.",
	"-Refer to the documentation.",
	"-Reach out for support."
]


static func get_message(type: Types, args: Array[String]) -> String:
	return messages[type] % args


static func get_column(line: String, key: String) -> int:
	return 0


static func process(script: ScriptData) -> Array[EditorError]:
	var actors: Array[Actor]
	var errors: Array[EditorError]
	var line_number: int = 0
	
	var lines = script.lines
	for line: String in script.lines:
		# no blank lines
		if line.is_empty():
			continue
		
		# trim the ends
		line = line.strip_edges()
		
		# separate the parts
		var args: PackedStringArray = line.split(" ")
		
		# check for initialization statements
		match args[0]:
			"#": # comment
				pass # nothing to check
			"scene": # scene 'name'
				if not line.contains("'"): # check for string
					errors.push_back(EditorError.new(
						Vector2(5, line_number), 
						get_message(Types.STRING_NOT_FOUND, ["'single'"])
					))
				elif line.count("'") < 2: # check for string closing
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.STRING_NOT_CLOSED, ["'"])
					))
				elif line.split("'")[1].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				elif line.split("'").size() > 2: # check for extra params
					var post_end: int = line.find("'", 7) + 1
					
					errors.push_back(EditorError.new(
						Vector2(post_end, line_number), 
						get_message(Types.NEEDLESS_PARAMS, [line.substr(post_end)])
					))
			"actor": # actor 'name' 'texture'
				if not line.contains("'"): # check for string
					errors.push_back(EditorError.new(
						Vector2(5, line_number), 
						get_message(Types.STRING_NOT_FOUND, ["'single'"])
					))
				elif line.count("'") < 2: # check for string closing
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.STRING_NOT_CLOSED, ["'"])
					))
				elif line.split("'")[1].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				elif line.count("'") < 3: # check for second string
					errors.push_back(EditorError.new(
						Vector2(line.find("'", line.find("'", 7) + 1), line_number), 
						get_message(Types.STRING_NOT_FOUND, ["'"])
					))
				elif line.count("'") < 4: # check for second string close
					errors.push_back(EditorError.new(
						Vector2(line.find("'", line.find("'", 7) + 1), line_number), 
						get_message(Types.STRING_NOT_CLOSED, ["'"])
					))
				elif line.split("'")[3].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(line.find("'", line.find("'", 7) + 1), line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				elif has_texture(line.split("'")[3]): # check is texture exists
					errors.push_back(EditorError.new(
						Vector2(line.find("'", line.find("'", 7) + 1), line_number), 
						get_message(Types.TEXTURE_NOT_RECOGNISED, [line.split("'")[3]])
					))
				elif line.split("'").size() > 4: # check for extra params
					var post_end: int = line.find("'", line.find("'", 7) + 1) + 1
					
					errors.push_back(EditorError.new(
						Vector2(post_end, line_number), 
						get_message(Types.NEEDLESS_PARAMS, [line.substr(post_end)])
					))
			"wait": # wait *duration*
				var duration = args[1]
				
				if not duration.is_valid_float():
					errors.push_back(EditorError.new(
						Vector2(5, line_number), 
						get_message(Types.INVALID_NUMBER, [duration])
					))
			"sound": # sound 'sound name' [-d *delay*] [-o || [-b *start time*] [-t *duration*] [-c *cycle*] [-v *volume*]]
				if not line.contains("'"): # check for string
					errors.push_back(EditorError.new(
						Vector2(5, line_number), 
						get_message(Types.STRING_NOT_FOUND, ["'single'"])
					))
				elif line.count("'") < 2: # check for string closing
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.STRING_NOT_CLOSED, ["'"])
					))
				elif line.split("'")[1].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				elif not has_audio(line.split("'")[1]): # check if audio exists
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.SOUND_NOT_RECOGNISED, [line.split("'")[1]])
					))
				else:
					# check each optional param
					var float_params: Array[String] = ["-d", "-b", "-t", "-c", "-v"]
					var all_params: Array[String] = float_params.duplicate()
					all_params.push_back("-o")
					
					var unknown_params: Array[String] = line.split("-")
					for segment in unknown_params:
						var param = "-%s" % segment.split(" ")[0]
						var param_index = line.find(param)
						if all_params.find(param) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + param.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [param, "sound"])
							))
						elif float_params.count(param):
							var value = line.substr(param_index).split(" ")[1]
							if not value.is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + param.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value])
								))
			"light": # light 'type' *rgba(red,green,blue,alpha)* [-o] [-d *delay*] [-l *location*]
				var type = line.split("'")[1]
				var color = get_color(line)
				var delay = get_optional_float("-d", args, 0.0)
				var off = has_optional_bool("-o", args)
				var location = get_optional_string("-l", args)
				
				#errors.push_back(EditorError.new(
					#Vector2(
						#get_column(line, args), line_number), 
						#get_message( , args)
				#))
			"narate": # narate "text" [-d *delay*] [-d *duration*]
				var dialog = get_dialogue(line)
				var delay = get_optional_float("-d", args, 0.0)
				var duration = get_optional_float("-t", args, 1.0)
				var wait = get_optional_bool("-w", args)
				
				#errors.push_back(EditorError.new(
					#Vector2(
						#get_column(line, args), line_number), 
						#get_message( , args)
				#))
			"speak": # speak 'actor' "text" [-t *dialog*] [-d *delay*] [-w]
				var actor_name = line.split("'")[1]
				var dialog = get_dialogue(line)
				var delay = get_optional_float("-d", args, 0.0)
				var duration = get_optional_float("-t", args, 1.0)
				var wait = get_optional_bool("-w", args)
				
				#errors.push_back(EditorError.new(
					#Vector2(
						#get_column(line, args), line_number), 
						#get_message( , args)
				#))
			"enter": # enter 'actor' *location* [-d *from*] [-t *duration*]
				var actor_name = line.split("'")[1]
				var location = args[2]
				var direction = get_optional_string("-dr", args)
				var duration = get_optional_float("-t", args, 1.0)
				
				#errors.push_back(EditorError.new(
					#Vector2(
						#get_column(line, args), line_number), 
						#get_message( , args)
				#))
			"exit": # exit 'actor' *location* [-d *to*] [-t *duration*]
				var actor_name = line.split("'")[1]
				var location = args[2]
				var direction = get_optional_string("-dr", args)
				var duration = get_optional_float("-t", args, 1.0)
				
				#errors.push_back(EditorError.new(
					#Vector2(
						#get_column(line, args), line_number), 
						#get_message( , args)
				#))
			"move": # move 'actor' *location* [-s *sub-location*]
				var actor_name = line.split("'")[1]
				var location = args[2]
				var duration = get_optional_float("-t", args, 1.0)
				
				#errors.push_back(EditorError.new(
					#Vector2(
						#get_column(line, args), line_number), 
						#get_message( , args)
				#))
			"animate": # animate 'actor' 'animation name' [-t *duration* || -c *cycle count*]
				var actor_name = line.split("'")[1]
				var animation = line.split("'")[3]
				var duration = get_optional_float("-t", args, 1.0)
				var cycle = get_optional_float("-c", args, 1.0)
				
				#errors.push_back(EditorError.new(
					#Vector2(
						#get_column(line, args), line_number), 
						#get_message( , args)
				#))
			_:
				errors.push_back(EditorError.new(
					Vector2(0,line_number), get_message(Types.ACTION_NOT_RECOGNISED, args)
				))
		
		line_number += 1
	
	return errors


static func get_quoted_text(line: String, place: int) -> String:
	return line.split("'")[place]


static func has_actor(actors: Array[Actor], actor_name: String) -> bool:
	for actor in actors:
		if actor.name == actor_name:
			return true
	return false


static func has_texture(filename: String) -> bool:
	var texture: Texture2D = Assets.textures[filename]
	return texture != null


static func has_audio(filename: String) -> bool:
	var sound: AudioStream = Assets.streams[filename]
	return sound != null


static func get_dialogue(line: String) -> String:
	var parts: PackedStringArray = line.split("\"")
	
	if parts.size() == 1:
		return ""
	else:
		return parts[1]


static func get_color(line: String) -> Color:
	var args = line.split("(")[1].split(")")[0].split(",")
	return Color(args[0] as float, args[1] as float, args[2] as float, args[3] as float)


static func get_optional_float(keyword: String, args: Array[String], default: float) -> float:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as float
	return default


static func has_optional_bool(keyword: String, args: Array[String]) -> bool:
	for i in args.size():
		if args[i] == keyword:
			return true
	return false


static func get_optional_bool(keyword: String, args: Array[String]) -> bool:
	for i in args.size():
		if args[i] == keyword:
			return true
	return false


static func get_optional_string(keyword: String, args: Array[String]) -> String:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as String
	return ""
