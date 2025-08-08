class_name ScriptInterpreter
extends Node


func process(script: ScriptData) -> Array[Command]:
	var actors: Array[Actor]
	var commands: Array[Command]
	var line_number: int
	
	for line: String in script.lines:
		var args: Array[String] = line.split(" ")
		
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
				
				commands.push_back(ActorCreateCommand.new(
					line_number, nickname, filename
				))
			"wait": # wait *duration*
				var duration = get_optional_param("-t", args) as float
				
				commands.push_back(WaitCommand.new(
					line_number, duration
				))
			"sound": # sound 'sound name' [-d *delay*] [-o || [-b *start time*] [-t *duration*] [-c *cycle*]]
				var sound = line.split("'")[1]
				var delay = get_optional_param("-d", args) as float
				var off = get_optional_param("-o", args) as bool
				var start = get_optional_param("-b", args) as float
				var duration = get_optional_param("-t", args) as float
				var cycle = get_optional_param("-c", args) as float
				
				commands.push_back(SoundCommand.new(
					line_number, sound, delay, start, duration, cycle, off
				))
			"light": # light *type* *rgba(red,green,blue,alpha)* [-o -d *delay*] [-l *location*]
				var type = line.split("'")[1]
				var color = line.split("(")[1].split(")")[0]
				var delay = get_optional_param("-d", args)
				var off = get_optional_param("-o", args)
				var location = get_optional_param("-l", args)
				
				commands.push_back(LightCommand.new(
					line_number, type, location, color, delay, off
				))
			_:
				# check for actor commands
				if args[0].ends_with(":"):
					var actor_name = args[0].replace(":","")
					var actor = get_actor(actors, actor_name)
					var id = actor.get_instance_id()
					var dialog = get_dialogue(line)
					
					match args[1]:
						"enter": # actor: enter *location* [-d *from*] [-t *duration*]
							var location = args[2]
							var direction = get_optional_param("-d", args) as float
							var duration = get_optional_param("-t", args) as float
							
							commands.push_back(ActorEnterCommand.new(
								line_number, id, location, direction, duration, dialog
							))
						"exit": # actor: exit *location* [-d *to*] [-t *duration*]
							var location = args[2]
							var direction = get_optional_param("-d", args) as float
							var duration = get_optional_param("-t", args) as float
							
							commands.push_back(ActorExitCommand.new(
								line_number, id, location, direction, duration, dialog
							))
						"move": # actor move *location* [-s *sub-location*]
							var location = args[2]
							var duration = get_optional_param("-t", args) as float
							
							commands.push_back(ActorMoveCommand.new(
								line_number, id, location, duration, dialog
							))
						"animate": # actor: animate 'animation name' [-t *duration* || -c *cycle count*]
							var animation = args[2]
							var duration = get_optional_param("-t", args) as float
							var cycle = get_optional_param("-c", args) as float
							
							commands.push_back(ActorAnimateCommand.new(
								line_number, id, animation, duration, cycle, dialog
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
	var parts: Array[String] = line.split("\"")
	
	if parts.size() == 1:
		return ""
	else:
		return parts[1]


func get_optional_param(keyword: String, args: Array[String]) -> String:
	for i in args.size():
		if args[i] == keyword:
			return args[i + 1]
	return ""
