class_name Actor
extends Node2D


signal finished()

@export var texture: Texture2D:
	set(value):
		texture = value
		if has_node("Sprite2D"):
			get_node("Sprite2D").texture = texture

@onready var animation: AnimationPlayer = $AnimationPlayer

var location: Stage.Location


func animate(command: ActorAnimateCommand) -> void:
	match command.animation:
		Stage.Animations.BOUNCE:
			animation.play("bounce")
		Stage.Animations.WOBBLE:
			animation.play("wobble")
		Stage.Animations.ROCK:
			animation.play("rock")
		Stage.Animations.SPIN:
			animation.play("spin")


func _on_animation_player_animation_finished(_anim_name):
	finished.emit()
