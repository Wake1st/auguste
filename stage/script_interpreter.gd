class_name ScriptInterpreter
extends Node


func process(script: ScriptData) -> Array[Command]:
	var actors: Array[Actor]
	var commands: Array[Command]
	var line_number: int = 1
	
	var lines = script.lines
	for line: String in script.lines:
		# no blank lines
		if line.is_empty():
			continue
		
		# separate the parts
		var args: PackedStringArray = line.split(" ")
		
		# check for initialization statements
		match args[0]:
			"#": # comment
				pass
			"scene": # scene 'name'
				var nickname = line.split("'")[1]
				
				commands.push_back(SceneCommand.new(
					line_number, nickname
				))
			"actor": # actor 'name' 'texture'
				var nickname = line.split("'")[1]
				var filename = line.split("'")[3] # skips cause there's a space
				
				var texture: Texture2D = Assets.textures[filename]
				commands.push_back(ActorCommand.new(
					line_number, nickname, texture
				))
			"wait": # wait *duration*
				var duration = args[1] as float
				
				commands.push_back(WaitCommand.new(
					line_number, duration
				))
			"sound": # sound 'sound name' [-d *delay*] [-o || [-b *start time*] [-t *duration*] [-c *cycle*] [-v *volume*]]
				var sound = line.split("'")[1]
				var delay = get_optional_float("-d", args, 0.0)
				var start = get_optional_float("-b", args, 0.0)
				var duration = get_optional_float("-t", args, -1.0)
				var cycle = get_optional_float("-c", args, 1.0)
				var volume = get_optional_float("-v", args, 0.0)
				var off = has_optional_bool("-o", args)
				
				commands.push_back(SoundCommand.new(
					line_number, sound, delay, start, duration, cycle, volume, off
				))
			"light": # light 'type' *rgba(red,green,blue,alpha)* [-o] [-d *delay*] [-l *location*]
				var type = line.split("'")[1]
				var color = get_color(line)
				var delay = get_optional_float("-d", args, 0.0)
				var off = has_optional_bool("-o", args)
				var location = get_optional_string("-l", args)
				
				commands.push_back(LightCommand.new(
					line_number, type, location, color, delay, off
				))
			"narate": # narate "text" [-d *delay*] [-d *duration*]
				var dialog = get_dialogue(line)
				var delay = get_optional_float("-d", args, 0.0)
				var duration = get_optional_float("-t", args, 1.0)
				var wait = get_optional_bool("-w", args)
				
				commands.push_back(NarationCommand.new(
					line_number, dialog, delay, duration, wait
				))
			"speak": # speak 'actor' "text" [-t *dialog*] [-d *delay*] [-w]
				var actor_name = line.split("'")[1]
				var dialog = get_dialogue(line)
				var delay = get_optional_float("-d", args, 0.0)
				var duration = get_optional_float("-t", args, 1.0)
				var wait = get_optional_bool("-w", args)
				
				commands.push_back(SpeakCommand.new(
					line_number, actor_name, dialog, delay, duration, wait
				))
			"enter": # enter 'actor' *location* [-d *from*] [-t *duration*]
				var actor_name = line.split("'")[1]
				var location = args[2]
				var direction = get_optional_string("-dr", args)
				var duration = get_optional_float("-t", args, 1.0)
				
				commands.push_back(EnterCommand.new(
					line_number, actor_name, location, direction, duration
				))
			"exit": # exit 'actor' *location* [-d *to*] [-t *duration*]
				var actor_name = line.split("'")[1]
				var location = args[2]
				var direction = get_optional_string("-dr", args)
				var duration = get_optional_float("-t", args, 1.0)
				
				commands.push_back(ExitCommand.new(
					line_number, actor_name, location, direction, duration
				))
			"move": # move 'actor' *location* [-s *sub-location*]
				var actor_name = line.split("'")[1]
				var location = args[2]
				var duration = get_optional_float("-t", args, 1.0)
				
				commands.push_back(MoveCommand.new(
					line_number, actor_name, location, duration
				))
			"animate": # animate 'actor' 'animation name' [-t *duration* || -c *cycle count*]
				var actor_name = line.split("'")[1]
				var animation = line.split("'")[3]
				var duration = get_optional_float("-t", args, 1.0)
				var cycle = get_optional_float("-c", args, 1.0)
				
				commands.push_back(AnimateCommand.new(
					line_number, actor_name, animation, duration, cycle
				))
			_:
				commands.push_back(ErrorCommand.new(
					line_number, 
					"Command not recognised: %s" % line
				))
		
		line_number += 1
	
	return commands


func get_quoted_text(line: String, place: int) -> String:
	return line.split("'")[place]


func get_actor(actors: Array[Actor], actor_name: String) -> Actor:
	for actor in actors:
		if actor.name == actor_name:
			return actor
	return null


func get_dialogue(line: String) -> String:
	var parts: PackedStringArray = line.split("\"")
	
	if parts.size() == 1:
		return ""
	else:
		return parts[1]


func get_color(line: String) -> Color:
	var args = line.split("(")[1].split(")")[0].split(",")
	return Color(args[0] as float, args[1] as float, args[2] as float, args[3] as float)


func get_optional_float(keyword: String, args: Array[String], default: float) -> float:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as float
	return default


func has_optional_bool(keyword: String, args: Array[String]) -> bool:
	for i in args.size():
		if args[i] == keyword:
			return true
	return false


func get_optional_bool(keyword: String, args: Array[String]) -> bool:
	for i in args.size():
		if args[i] == keyword:
			return true
	return false


func get_optional_string(keyword: String, args: Array[String]) -> String:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as String
	return ""
