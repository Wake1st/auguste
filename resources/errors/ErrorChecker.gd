class_name ErrorChecker


enum Types {
	ACTION_NOT_RECOGNISED,
	PARAM_NOT_RECOGNISED,
	ACTOR_NOT_RECOGNISED,
	TEXTURE_NOT_RECOGNISED,
	SOUND_NOT_RECOGNISED,
	LIGHT_NOT_RECOGNISED,
	ANIMATION_NOT_RECOGNISED,
	LOCATION_NOT_RECOGNISED,
	DIRECTION_NOT_RECOGNISED,
	INVALID_NUMBER,
	STRING_NOT_FOUND,
	STRING_NOT_CLOSED,
	STRING_EMPTY,
	NEEDLESS_PARAMS,
	FUNCTION_MISSING_PARENTHESES,
	FUNCTION_MISSING_ARGS,
	MISSING_PARAM,
}

static var messages: Dictionary[Types, String] = {
	Types.ACTION_NOT_RECOGNISED: "'%s' is not an action.",
	Types.PARAM_NOT_RECOGNISED: "'%s' is not a param for '%s'.",
	Types.ACTOR_NOT_RECOGNISED: "Cannot find actor '%s'.",
	Types.TEXTURE_NOT_RECOGNISED: "Cannot find texture '%s'.",
	Types.SOUND_NOT_RECOGNISED: "Cannot find sound '%s'.",
	Types.LIGHT_NOT_RECOGNISED: "'%s' is not a light type.",
	Types.ANIMATION_NOT_RECOGNISED: "'%s' is not an animation.",
	Types.LOCATION_NOT_RECOGNISED: "'%s' is not a location.",
	Types.DIRECTION_NOT_RECOGNISED: "'%s' is not a direction.",
	Types.INVALID_NUMBER: "'%s' is not a valid number.",
	Types.STRING_NOT_FOUND: "A string using %s quotes should be here.",
	Types.STRING_NOT_CLOSED: "String must be closed with a matching %s symbol.",
	Types.STRING_EMPTY: "Strings cannot be empty.",
	Types.NEEDLESS_PARAMS: "These params mean nothing and should be removed: %s",
	Types.FUNCTION_MISSING_PARENTHESES: "Functions must have opening and closing '()'.",
	Types.FUNCTION_MISSING_ARGS: "This function requires %s params.",
	Types.MISSING_PARAM: "%s keyword expects the param [%s]."
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
				elif line.split("'").size() > 3 && not line.split("'")[2].is_empty(): # check for extra params
					var post_end: int = line.find("'", 7) + 1
					
					errors.push_back(EditorError.new(
						Vector2(post_end, line_number), 
						get_message(Types.NEEDLESS_PARAMS, [line.substr(post_end)])
					))
			"actor": # actor 'name' 'texture'
				var single_quote_split: PackedStringArray = line.split("'")
				
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
				elif single_quote_split[1].is_empty(): # check for string content
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
				elif single_quote_split[3].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(line.find("'", line.find("'", 7) + 1), line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				elif not has_texture(single_quote_split[3]): # check is texture exists
					errors.push_back(EditorError.new(
						Vector2(line.find("'", line.find("'", 7) + 1), line_number), 
						get_message(Types.TEXTURE_NOT_RECOGNISED, [single_quote_split[3]])
					))
				elif single_quote_split.size() > 5 && not single_quote_split[4].is_empty(): # check for extra params
					var post_end: int = find_nth_char(line, "'", 4) + 1
					
					errors.push_back(EditorError.new(
						Vector2(post_end, line_number), 
						get_message(Types.NEEDLESS_PARAMS, [line.substr(post_end)])
					))
			"wait": # wait *duration*
				var duration = args[1]
				
				if args.size() < 2: # check for second arg
					errors.push_back(EditorError.new(
						Vector2(4, line_number), 
						get_message(Types.MISSING_PARAM, ["wait", "duration"])
					))
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
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "sound"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
			"light": # light 'type' *rgba(red,green,blue,alpha)* [-o] [-d *delay*] [-l *location*]
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
				elif not is_light(line.split("'")[1]): # check if light type exists
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.LIGHT_NOT_RECOGNISED, [line.split("'")[1]])
					))
				elif line.contains("spot") && not line.contains("-l"): # check spot for location
					var location = get_optional_string("-l", args)
					
					if not is_location(location):
						errors.push_back(EditorError.new(
							Vector2(line.find("-l") + 3, line_number), 
							get_message(Types.LOCATION_NOT_RECOGNISED, location)
						))
				elif line.contains("rgba"): # check the color
					if not line.contains("(") || not line.contains(")"): # check parentheses
						errors.push_back(EditorError.new(
							Vector2(line.find("rgba") + 4, line_number), 
							get_message(Types.FUNCTION_MISSING_PARENTHESES, [])
						))
					elif line.count(",") < 3: # check for param count
						errors.push_back(EditorError.new(
							Vector2(line.find("rgba") + 4, line_number), 
							get_message(Types.FUNCTION_MISSING_ARGS, ["4"])
						))
					else: # ensure params are all floats
						var color_params: PackedStringArray = line.split("(")[1].split(")")[0].split(",")
						
						for index in color_params.size(): 
							if not color_params[index].strip_edges().is_valid_float():
								if index == 0: # the first param comes after the '('
									errors.push_back(EditorError.new(
										Vector2(line.find("(") + 1, line_number), 
										get_message(Types.INVALID_NUMBER, [color_params[index]])
									))
								else:
									errors.push_back(EditorError.new(
										Vector2(find_nth_char(line, ",", index), line_number), 
										get_message(Types.INVALID_NUMBER, [color_params[index]])
									))
				else:
					# check each optional param
					var float_params: Array[String] = ["-d"]
					var all_params: Array[String] = float_params.duplicate()
					all_params.push_back("-o")
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "light"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
			"narate": # narate "text" [-d *delay*] [-d *duration*] [-w]
				if not line.contains("\""): # check for string
					errors.push_back(EditorError.new(
						Vector2(6, line_number), 
						get_message(Types.STRING_NOT_FOUND, ["\"double\""])
					))
				elif line.count("\"") < 2: # check for string closing
					errors.push_back(EditorError.new(
						Vector2(7, line_number), 
						get_message(Types.STRING_NOT_CLOSED, ["\""])
					))
				elif line.split("\"")[1].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(7, line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				else:
					# check each optional param
					var float_params: Array[String] = ["-d", "-t"]
					var all_params: Array[String] = float_params.duplicate()
					all_params.push_back("-w")
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "narate"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
			"speak": # speak 'actor' "text" [-t *dialog*] [-d *delay*] [-w]
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
				elif not line.contains("\""): # check for string
					errors.push_back(EditorError.new(
						Vector2(find_nth_char(line, "'", 2), line_number), 
						get_message(Types.STRING_NOT_FOUND, ["\"double\""])
					))
				elif line.count("\"") < 2: # check for string closing
					errors.push_back(EditorError.new(
						Vector2(line.find("\""), line_number), 
						get_message(Types.STRING_NOT_CLOSED, ["\""])
					))
				elif line.split("\"")[1].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(line.find("\""), line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				else:
					# check each optional param
					var float_params: Array[String] = ["-d", "-t"]
					var all_params: Array[String] = float_params.duplicate()
					all_params.push_back("-w")
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "narate"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
			"enter": # enter 'actor' *location* [-dr *from*] [-t *duration*]
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
				elif args.size() < 3: # check for location param
					errors.push_back(EditorError.new(
						Vector2(find_nth_char(line, "'", 2), line_number), 
						get_message(Types.MISSING_PARAM, ["location"])
					))
				elif not is_location(args[2]): # check location type
					errors.push_back(EditorError.new(
						Vector2(line.find(args[2]), line_number), 
						get_message(Types.LOCATION_NOT_RECOGNISED, [args[2]])
					))
				else:
					# check each optional param
					var float_params: Array[String] = ["-t"]
					var all_params: Array[String] = float_params.duplicate()
					all_params.push_back("-dr")
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "enter"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
					
					# check location
					if line.count("-dr"):
						var direction_index = line.find("-dr")
						var direction_args = line.substr(direction_index).split(" ")
						if direction_args.size() < 2:
							errors.push_back(EditorError.new(
								Vector2(direction_index + 3, line_number), 
								get_message(Types.MISSING_PARAM, ["direction"])
							))
						elif not is_direction(direction_args[1]):
							errors.push_back(EditorError.new(
								Vector2(direction_index + 4, line_number), 
								get_message(Types.DIRECTION_NOT_RECOGNISED, [direction_args[1]])
							))
			"exit": # exit 'actor' *location* [-d *to*] [-t *duration*]
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
				elif args.size() < 3: # check for location param
					errors.push_back(EditorError.new(
						Vector2(find_nth_char(line, "'", 2), line_number), 
						get_message(Types.MISSING_PARAM, ["location"])
					))
				elif not is_location(args[2]): # check location type
					errors.push_back(EditorError.new(
						Vector2(line.find(args[2]), line_number), 
						get_message(Types.LOCATION_NOT_RECOGNISED, [args[2]])
					))
				else:
					# check each optional param
					var float_params: Array[String] = ["-t"]
					var all_params: Array[String] = float_params.duplicate()
					all_params.push_back("-dr")
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "exit"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
					
					# check location
					if line.count("-dr"):
						var direction_index = line.find("-dr")
						var direction_args = line.substr(direction_index).split(" ")
						if direction_args.size() < 2:
							errors.push_back(EditorError.new(
								Vector2(direction_index + 3, line_number), 
								get_message(Types.MISSING_PARAM, ["direction"])
							))
						elif not is_direction(direction_args[1]):
							errors.push_back(EditorError.new(
								Vector2(direction_index + 4, line_number), 
								get_message(Types.DIRECTION_NOT_RECOGNISED, [direction_args[1]])
							))
			"move": # move 'actor' *location* [-t *duration*]
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
				elif args.size() < 3: # check for location param
					errors.push_back(EditorError.new(
						Vector2(find_nth_char(line, "'", 2), line_number), 
						get_message(Types.MISSING_PARAM, ["location"])
					))
				elif not is_location(args[2]): # check location type
					errors.push_back(EditorError.new(
						Vector2(line.find(args[2]), line_number), 
						get_message(Types.LOCATION_NOT_RECOGNISED, [args[2]])
					))
				else:
					# check each optional param
					var float_params: Array[String] = ["-t"]
					var all_params: Array[String] = float_params.duplicate()
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "exit"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
			"animate": # animate 'actor' 'animation name' [-t *duration* || -c *cycle count*]
				var animation = line.split("'")[3]
				
				if not line.contains("'"): # check for string
					errors.push_back(EditorError.new(
						Vector2(7, line_number), 
						get_message(Types.STRING_NOT_FOUND, ["'single'"])
					))
				elif line.count("'") < 2: # check for string closing
					errors.push_back(EditorError.new(
						Vector2(8, line_number), 
						get_message(Types.STRING_NOT_CLOSED, ["'"])
					))
				elif line.split("'")[1].is_empty(): # check for string content
					errors.push_back(EditorError.new(
						Vector2(8, line_number), 
						get_message(Types.STRING_EMPTY, [])
					))
				elif line.count("'") < 4: # check for animation param
					errors.push_back(EditorError.new(
						Vector2(find_nth_char(line, "'", 2), line_number), 
						get_message(Types.MISSING_PARAM, ["animation"])
					))
				elif not is_animation(animation): # check animation type
					errors.push_back(EditorError.new(
						Vector2(line.find(animation), line_number), 
						get_message(Types.ANIMATION_NOT_RECOGNISED, [animation])
					))
				else:
					# check each optional param
					var float_params: Array[String] = ["-t", "-c"]
					var all_params: Array[String] = float_params.duplicate()
					
					for arg in args:
						if not arg.contains(" -"): # skip non optional params
							continue
						
						var param_index = line.find(arg)
						if all_params.find(arg) == -1:
							errors.push_back(EditorError.new(
								Vector2(param_index + arg.length() + 1, line_number), 
								get_message(Types.PARAM_NOT_RECOGNISED, [arg, "exit"])
							))
						elif float_params.count(arg) > 0:
							var value_params = line.substr(param_index).split(" ")
							if value_params.size() < 2:
								errors.push_back(EditorError.new(
									Vector2(param_index, line_number),
									get_message(Types.MISSING_PARAM, [value_params[0]])
								))
							elif not value_params[1].is_valid_float():
								errors.push_back(EditorError.new(
									Vector2(param_index + arg.length() + 1, line_number), 
									get_message(Types.INVALID_NUMBER, [value_params[1]])
								))
			_:
				errors.push_back(EditorError.new(
					Vector2(0,line_number), get_message(Types.ACTION_NOT_RECOGNISED, args)
				))
		
		line_number += 1
	
	return errors


static func has_texture(filename: String) -> bool:
	return Assets.textures.has(filename)


static func has_audio(filename: String) -> bool:
	return Assets.streams.has(filename)


static func is_light(type: String) -> bool:
	return type.to_lower() == "spot" || type.to_lower() == "fresnel"


static func is_location(location: String) -> bool:
	for key: String in Stage.Location.keys():
		if key == location.to_upper().replace("-","_"):
			return true
	return false


static func is_direction(direction: String) -> bool:
	for key: String in Stage.Direction.keys():
		if key.to_lower() == direction.to_lower():
			return true
	return false


static func is_animation(animation: String) -> bool:
	for key: String in Stage.Animations.keys():
		if key.to_lower() == animation.to_lower():
			return true
	return false


static func get_optional_string(keyword: String, args: Array[String]) -> String:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as String
	return ""


static func find_nth_char(line: String, character: String, count: int) -> int:
	var stepping_index: int = 0
	while count > 0:
		stepping_index = line.find(character, stepping_index) + 1
		count -= 1
	
	return stepping_index
