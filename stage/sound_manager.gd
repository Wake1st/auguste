class_name SoundManager
extends Node


const STAGE_SOUND = preload("res://stage/stage_sound.tscn")

var completion_callable: Callable
var players: Array[StageSound]


func setup(callable: Callable) -> void:
	completion_callable = callable


func play(command: SoundCommand) -> void:
	var player: StageSound = STAGE_SOUND.instantiate()
	
	add_child(player)
	players.push_back(player)
	
	player.completed.connect(completion_callable)
	player.run(command)
