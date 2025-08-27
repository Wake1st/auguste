class_name SoundManager
extends Node


const STAGE_SOUND = preload("res://stage/stage_sound.tscn")

var completion_callable: Callable
var players: Array[StageSound]


func setup(callable: Callable) -> void:
	completion_callable = callable


func process(command: SoundCommand) -> void:
	if command.shouldStop:
		# find it and destroy it
		var stage_sounds = players.filter(
			func(sound): return sound.name == command.name
		)
		if not stage_sounds.is_empty():
			stage_sounds.front().stop()
		completion_callable.call(command.has_delay())
	else:
		var player: StageSound = STAGE_SOUND.instantiate()
		
		add_child(player)
		players.push_back(player)
		
		player.completed.connect(completion_callable)
		player.run(command)
