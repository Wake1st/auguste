class_name AudioDisplay
extends Panel

@onready var btn_play: Button = $MarginContainer/VBoxContainer/BtnPlay
@onready var btn_pause: Button = $MarginContainer/VBoxContainer/BtnPause
@onready var btn_stop: Button = $MarginContainer/VBoxContainer/BtnStop

@onready var player: AudioStreamPlayer = $AudioStreamPlayer

var stream: AudioStream
var playtime: float


func add(audio: AudioStream) -> void:
	stream = audio
	player.stream = stream


func _on_btn_play_pressed() -> void:
	if player.stream_paused:
		player.play(playtime)
	else:
		player.play()
	
	btn_play.disabled = true
	btn_pause.disabled = false
	btn_stop.disabled = false


func _on_btn_pause_pressed() -> void:
	player.stream_paused = true
	playtime = player.get_playback_position()
	
	btn_play.disabled = false
	btn_pause.disabled = true
	btn_stop.disabled = true


func _on_btn_stop_pressed() -> void:
	player.stop()
	
	btn_play.disabled = false
	btn_pause.disabled = true
	btn_stop.disabled = true
