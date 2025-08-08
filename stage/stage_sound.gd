class_name StageSound
extends AudioStreamPlayer


signal completed(sound_name: String)

@onready var timer: Timer = $Timer

var command: SoundCommand
#var isDelayed: bool
var counter: int


func run(cmd: SoundCommand) -> void:
	command = cmd
	
	name = command.name
	stream = Assets.streams[command.name]
	counter = command.cycle
	
	if command.delay > 0.0:
		#isDelayed = true
		timer.start(command.delay)
	else:
		_play_sound()


func _play_sound() -> void:
	if counter > 0:
		counter -= 1
		play(command.start)
		
		if command.duration > 0:
			timer.start(command.duration)
	else:
		completed.emit(command.name)


func _on_timer_timeout() -> void:
	#if isDelayed:
		#isDelayed = false
	_play_sound()


func _on_finished():
	_play_sound()
