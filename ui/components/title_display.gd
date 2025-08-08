class_name TitleDisplay
extends Control


signal finished()

@onready var label: Label = %Label
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var isOpen: bool


func display(text: String) -> void:
	label.text = text
	isOpen = true
	animation.play("slide")


func _on_animation_player_animation_finished(anim_name) -> void:
	if isOpen:
		timer.start()
	else:
		finished.emit()


func _on_timer_timeout() -> void:
	isOpen = false
	animation.play_backwards("slide")
