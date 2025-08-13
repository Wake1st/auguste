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

signal finished()

const ACTOR_SCENE = preload("res://stage/actor.tscn")

@export var spawn_point: Marker2D

@onready var interpreter: ScriptInterpreter = $ScriptInterpreter
@onready var sound_manager: SoundManager = $SoundManager
@onready var location_manager: LocationManager = $LocationManager
@onready var wait_timer: Timer = %WaitTimer
@onready var dialog_display: DialogDisplay = %DialogDisplay
@onready var title_display: TitleDisplay = %TitleDisplay

@onready var delay_timers: Node = $DelayTimers
@onready var actor_node: Node2D = $Actors

var commands: Array[Command]
var command_index: int = -1
var actors: Dictionary[String, Actor]


func run(script: ScriptData) -> void:
	commands = interpreter.process(script)
	_next_command()


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
		_delay_command(command)
		_next_command()
	else:
		_run(command)


func _ready() -> void:
	sound_manager.setup(_on_command_finished)
	location_manager.setup(_on_command_finished)
	dialog_display.finished.connect(_on_command_finished)
	title_display.finished.connect(_on_command_finished)


func _run(command: Command) -> void:
	if command is SceneCommand:
		# display title card
		title_display.display((command as SceneCommand).name)
	elif command is ActorCommand:
		# create an actor
		var actor: Actor = ACTOR_SCENE.instantiate()
		actor.name = (command as ActorCommand).name
		actor.texture = (command as ActorCommand).texture
		actor.finished.connect(_on_command_finished)
		
		actor_node.add_child(actor)
		actor.position = spawn_point.position
		actors.set(actor.name, actor)
		
		_on_command_finished()
		return	# ensure we end function after calling finished
	elif command is SoundCommand:
		# add sound to manager and play
		sound_manager.process(command as SoundCommand)
	elif command is LightCommand:
		# set location light
		location_manager.light_command(command as LightCommand)
	elif command is WaitCommand:
		# waits with dramatic pause
		wait_timer.start((command as WaitCommand).duration)
	elif command is NarationCommand:
		dialog_display.show_naration(command)
	elif command is SpeakCommand:
		var actor_command = command as SpeakCommand
		var actor: Actor = actors[actor_command.name]
		dialog_display.show_dialog(actor, actor_command)
	elif command is EnterCommand:
		var actor_command = command as EnterCommand
		var actor: Actor = actors[actor_command.name]
		location_manager.enter_actor(actor, actor_command)
	elif command is ExitCommand:
		var actor_command = command as ExitCommand
		var actor: Actor = actors[actor_command.name]
		location_manager.exit_actor(actor, actor_command)
	elif command is MoveCommand:
		var actor_command = command as MoveCommand
		var actor: Actor = actors[actor_command.name]
		location_manager.send_actor(actor, actor_command)
	elif command is AnimateCommand:
		var actor_command = command as AnimateCommand
		var actor: Actor = actors[actor_command.name]
		actor.animate(actor_command)
	elif command is ErrorCommand:
		# TODO: errors should have their own UI
		print((command as ErrorCommand).msg())
		#dialog_display.show_naration((command as ErrorCommand).msg())


func _delay_command(command: Command) -> void:
	var timer: Timer = Timer.new()
	delay_timers.add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_delay_timer_finished.bind(timer, command))
	timer.start(command.delay)

func _on_delay_timer_finished(timer: Timer, command: Command) -> void:
	_run(command)
	timer.queue_free()

func _on_command_finished(wasDelayed: bool = false) -> void:
	if not wasDelayed:
		_next_command()
