class_name StageSound
extends AudioStreamPlayer


signal completed()

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
	
	if command.delay > 0.0:
		timer.start(command.delay)
	else:
		_play_sound()
	
	# run the next command
	completed.emit()


func _play_sound() -> void:
	if counter > 0:
		counter -= 1
		play(command.start)
		
		if command.duration > 0:
			isDurated = true
			timer.start(command.duration)
	else:
		# ensure we don't call it twice
		completed.emit()


func _on_timer_timeout() -> void:
	if isDurated:
		isDurated = false
		stop()
	_play_sound()


func _on_finished():
	_play_sound()
