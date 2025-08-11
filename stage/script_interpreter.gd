class_name ScriptInterpreter
extends Node


func process(script: ScriptData) -> Array[Command]:
	var actors: Array[Actor]
	var commands: Array[Command]
	var line_number: int = 0
	
	var lines = script.lines
	for line: String in script.lines:
		# no blank lines
		if line.is_empty():
			continue
		
		# separate the parts
		var args: PackedStringArray = line.split(" ")
		
		# check for initialization statements
		match args[0]:
			"scene": # scene 'name'
				var nickname = line.split("'")[1]
				
				commands.push_back(SceneCreateCommand.new(
					line_number, nickname
				))
			"actor": # actor 'name' 'texture'
				var nickname = line.split("'")[1]
				var filename = line.split("'")[3] # skips cause there's a space
				
				var texture: Texture2D = Assets.textures[filename]
				commands.push_back(ActorCreateCommand.new(
					line_number, nickname, texture
				))
			"wait": # wait *duration*
				var duration = args[1] as float
				
				commands.push_back(WaitCommand.new(
					line_number, duration
				))
			"sound": # sound 'sound name' [-d *delay*] [-o || [-b *start time*] [-t *duration*] [-c *cycle*]] [-v *volume*] [-p]
				var sound = line.split("'")[1]
				var delay = get_optional_float("-d", args)
				var start = get_optional_float("-b", args)
				var duration = get_optional_float("-t", args)
				var cycle = get_optional_float("-c", args)
				var volume = get_optional_float("-v", args)
				var off = has_optional_bool("-o", args)
				var playthrough = has_optional_bool("-p", args)
				
				cycle = cycle if cycle > 0.0 else 1.0
				
				commands.push_back(SoundCommand.new(
					line_number, sound, delay, start, duration, cycle, volume, off, playthrough
				))
			"light": # light *type* *rgba(red,green,blue,alpha)* [-o -d *delay*] [-l *location*]
				var type = line.split("'")[1]
				var color = get_color(line)
				var delay = get_optional_float("-d", args)
				var off = has_optional_bool("-o", args)
				var location = get_optional_string("-l", args)
				
				commands.push_back(LightCommand.new(
					line_number, type, location, color, delay, off
				))
			_:
				# check for actor commands
				if args[0].ends_with(":"):
					var actor_name = args[0].replace(":","")
					var dialog = get_dialogue(line)
					
					match args[1]:
						"enter": # actor: enter *location* [-d *from*] [-t *duration*]
							var location = args[2]
							var direction = get_optional_string("-d", args)
							var duration = get_optional_float("-t", args)
							
							commands.push_back(ActorEnterCommand.new(
								line_number, actor_name, location, direction, duration, dialog
							))
						"exit": # actor: exit *location* [-d *to*] [-t *duration*]
							var location = args[2]
							var direction = get_optional_string("-d", args)
							var duration = get_optional_float("-t", args)
							
							commands.push_back(ActorExitCommand.new(
								line_number, actor_name, location, direction, duration, dialog
							))
						"move": # actor move *location* [-s *sub-location*]
							var location = args[2]
							var duration = get_optional_float("-t", args)
							
							commands.push_back(ActorMoveCommand.new(
								line_number, actor_name, location, duration, dialog
							))
						"animate": # actor: animate 'animation name' [-t *duration* || -c *cycle count*]
							var animation = line.split("'")[1]
							var duration = get_optional_float("-t", args)
							var cycle = get_optional_float("-c", args)
							
							commands.push_back(ActorAnimateCommand.new(
								line_number, actor_name, animation, duration, cycle, dialog
							))
				else:
					commands.push_back(ErrorCommand.new(
						line_number, 
						"Expected semi-colon (:) after character name -> check %s" % args[0]
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
	return Color(args[0] as int, args[1] as int, args[2] as int, args[3] as int)


func get_optional_float(keyword: String, args: Array[String]) -> float:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as float
	return 0.0


func has_optional_bool(keyword: String, args: Array[String]) -> bool:
	for i in args.size():
		if args[i] == keyword:
			return true
	return false


func get_optional_bool(keyword: String, args: Array[String]) -> bool:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as bool
	return false


func get_optional_string(keyword: String, args: Array[String]) -> String:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1] as String
	return ""
