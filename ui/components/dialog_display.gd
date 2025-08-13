class_name DialogDisplay
extends Control


signal finished()

const CHARACTERS_PER_SECOND: int = 100

@onready var lbl_name: Label = %LblName
@onready var text_rect: TextureRect = %TextureRect
@onready var lbl_dialog: RichTextLabel = %RichTextLabel

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

var isOpen: bool
var duration: float


func show_naration(command: NarationCommand) -> void:
	lbl_name.text = "naration"
	text_rect.texture = null
	
	lbl_dialog.visible_ratio = 0.0
	lbl_dialog.text = command.dialog
	
	duration = command.duration
	_toggle_open()


func show_dialog(character_name: String, texture: Texture2D, dialog: String) -> void:
	lbl_name.text = character_name
	text_rect.texture = texture
	
	lbl_dialog.visible_ratio = 0.0
	lbl_dialog.text = dialog
	
	_toggle_open()


func _toggle_open() -> void:
	if isOpen:
		_type_text()
	else:
		isOpen = true
		animation.play("slide")


func toggle_close() -> void:
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


func _on_timer_timeout():
	finished.emit()
