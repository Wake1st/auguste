class_name StageSound
extends AudioStreamPlayer


signal completed(wasDelayed: bool)

@onready var timer: Timer = $Timer

var command: SoundCommand
var isDurated: bool
var counter: float


func run(cmd: SoundCommand) -> void:
	command = cmd
	
	name = command.name
	stream = Assets.streams[command.name]
	volume_db = command.volume
	counter = command.cycle
	
	_play_sound()
	
	# run the next command
	completed.emit(command.has_delay())


func _play_sound() -> void:
	if counter > 0:
		counter -= 1
		play(command.start)
		
		if command.duration > 0:
			isDurated = true
			timer.start(command.duration)


func _on_timer_timeout() -> void:
	if isDurated:
		isDurated = false
		stop()
	_play_sound()


func _on_finished():
	_play_sound()
