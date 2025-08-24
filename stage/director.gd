class_name Director
extends Node


signal finished()

@export var stage: Stage

@onready var interpreter: ScriptInterpreter = $ScriptInterpreter

var commands: Array[Command]
var command_index: int = -1


func run(script: ScriptData) -> void:
	commands = interpreter.process(script)
	_next_command()


func _ready() -> void:
	stage.setup(_handle_command_finished)


func _next_command() -> void:
	# increment and check for end of command
	command_index += 1
	if command_index >= commands.size():
		finished.emit()
		return
	
	# process the new command
	var command = commands[command_index]
	
	# delayed commands will be bound to a timer
	if command.has_delay():
		stage.delay_command(command)
		_next_command()
	else:
		stage.run(command)


func _handle_command_finished(wasDelayed: bool = false, waitTime: float = -1.0) -> void:
	if waitTime > 0.0:
		await stage.force_wait(waitTime)
	
	if not wasDelayed:
		_next_command()
