class_name Actor
extends Node2D


signal finished()

@export var texture: Texture2D:
	set(value):
		texture = value
		if has_node("Sprite2D"):
			get_node("Sprite2D").texture = texture

@onready var player: AnimationPlayer = $AnimationPlayer

var location: Stage.Location
var current_animation: ActorAnimateCommand


func animate(command: ActorAnimateCommand) -> void:
	current_animation = command
	_cycle_animation()


func _cycle_animation() -> void:
	if current_animation.cycle > 0:
		current_animation.cycle -= 1
		player.speed_scale = 1 / current_animation.duration
		
		match current_animation.animation:
			Stage.Animations.BOUNCE:
				player.play("bounce")
			Stage.Animations.WOBBLE:
				player.play("wobble")
			Stage.Animations.ROCK:
				player.play("rock")
			Stage.Animations.SPIN:
				player.play("spin")
	else:
		player.stop()
		finished.emit()


func _on_animation_player_animation_finished(_anim_name) -> void:
	_cycle_animation()
