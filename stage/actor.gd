class_name Actor
extends Sprite2D


signal finished()

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


func _on_animation_player_animation_finished(anim_name):
	finished.emit()
