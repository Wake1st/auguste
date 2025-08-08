class_name Stage
extends Node2D


#region Enums
enum Location {
	OFF,
	UP_LEFT,
	UP_CENTER,
	UP_RIGHT,
	LEFT,
	CENTER,
	RIGHT,
	DOWN_LEFT,
	DOWN_CENTER,
	DOWN_RIGHT
}

enum Direction {
	BELOW,
	ABOVE,
	RIGHT,
	LEFT,
}

enum Light {
	SPOT,
	FRESNEL,
}

enum Animations {
	BOUNCE,
	WOBBLE,
	ROCK,
	SPIN,
}
#endregion

const ACTOR_SCENE = preload("res://stage/actor.tscn")

@onready var interpreter: ScriptInterpreter = $ScriptInterpreter
@onready var sound_manager: SoundManager = $SoundManager
@onready var location_manager: LocationManager = $LocationManager
@onready var wait_timer: Timer = $WaitTimer
@onready var dialog_display: DialogDisplay = %DialogDisplay
@onready var title_display: TitleDisplay = %TitleDisplay

@onready var actor_node: Node2D = $Actors

var commands: Array[Command]
var command_index: int
var actors: Dictionary[String, Actor]


func run(script: ScriptData) -> void:
	commands = interpreter.process(script)
	_next_command()


func _next_command() -> void:
	command_index += 1
	var command = commands[command_index]
	var hasDialog: bool
	
	if command is SceneCreateCommand:
		# display title card
		title_display.display((command as SceneCreateCommand).name)
	elif command is ActorCreateCommand:
		# create an actor
		var actor: Actor = ACTOR_SCENE.instantiate()
		actor.name = (command as ActorCreateCommand).name
		actor.texture = (command as ActorCreateCommand).texture
		actor_node.add_child(actor)
		actors.set(actor.get_instance_id(), actor)
		
		_on_command_finished()
	elif command is SoundCommand:
		# add sound to manager and play
		sound_manager.play(command as SoundCommand)
	elif command is LightCommand:
		# set location light
		location_manager.light_command(command as LightCommand)
	elif command is WaitCommand:
		# waits with dramatic pause
		wait_timer.start((command as WaitCommand).duration)
	elif command is NarationCommand:
		dialog_display.show_naration(command.dialog)
		hasDialog = true
	elif command is ActorEnterCommand:
		var actor_command = command as ActorEnterCommand
		var actor: Actor = actors[actor_command.id]
		
		if command.has_dialog():
			dialog_display.show_dialog(actor.name, actor.texture, command.dialog)
			hasDialog = true
	elif command is ActorExitCommand:
		var actor_command = command as ActorExitCommand
		var actor: Actor = actors[actor_command.id]
		
		if command.has_dialog():
			dialog_display.show_dialog(actor.name, actor.texture, command.dialog)
			hasDialog = true
	elif command is ActorMoveCommand:
		var actor_command = command as ActorMoveCommand
		var actor: Actor = actors[actor_command.id]
		
		if command.has_dialog():
			dialog_display.show_dialog(actor.name, actor.texture, command.dialog)
			hasDialog = true
	elif command is ActorAnimateCommand:
		var actor_command = command as ActorAnimateCommand
		var actor: Actor = actors[actor_command.id]
		
		if command.has_dialog():
			dialog_display.show_dialog(actor.name, actor.texture, command.dialog)
			hasDialog = true
	elif command is ErrorCommand:
		dialog_display.show_naration((command as ErrorCommand).msg())
		hasDialog = true
	
	# check to see if dialogue needs to be kept
	if not hasDialog:
		dialog_display.toggle_close()


func _ready() -> void:
	sound_manager.setup(_on_command_finished)
	location_manager.setup(_on_command_finished)
	dialog_display.finished.connect(_on_command_finished)
	title_display.finished.connect(_on_command_finished)


func _on_command_finished() -> void:
	_next_command()
