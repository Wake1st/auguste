class_name DialogDisplay
extends Control


signal finished(wasDelayed: bool)

const CHARACTERS_PER_SECOND: int = 100

@onready var lbl_name: Label = %LblName
@onready var text_rect: TextureRect = %TextureRect
@onready var lbl_dialog: RichTextLabel = %RichTextLabel

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var isOpen: bool
var wasDelayed: float
var shouldWait: bool
var duration: float


func show_naration(command: NarationCommand) -> void:
	lbl_name.text = "naration"
	text_rect.texture = null
	
	lbl_dialog.visible_ratio = 0.0
	lbl_dialog.text = command.dialog
	
	wasDelayed = command.has_delay()
	duration = command.duration
	shouldWait = command.wait
	
	_toggle_open()


func show_dialog(actor: Actor, command: SpeakCommand) -> void:
	lbl_name.text = actor.name
	text_rect.texture = actor.texture
	
	lbl_dialog.visible_ratio = 0.0
	lbl_dialog.text = command.dialog
	
	wasDelayed = command.has_delay()
	duration = command.duration
	shouldWait = command.wait
	
	_toggle_open()


func _toggle_open() -> void:
	if isOpen:
		# override old times
		timer.stop()
		_type_text()
	else:
		isOpen = true
		animation.play("slide")

func _toggle_close() -> void:
	if isOpen:
		isOpen = false
		animation.play_backwards("slide")

func _type_text() -> void:
	animation.speed_scale = CHARACTERS_PER_SECOND / lbl_dialog.text.length()
	animation.play("type")

func _on_animation_player_animation_finished(anim_name) -> void:
	if anim_name == "slide" && isOpen:
		_type_text()
	elif anim_name == "type":
		timer.start(duration)
		finished.emit(wasDelayed, duration if shouldWait else 0.0)

func _on_timer_timeout():
	_toggle_close()
