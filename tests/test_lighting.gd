extends Node2D


@onready var actor: Actor = $Actor
@onready var location: Location = $Location


func _ready() -> void:
	location.send_actor(actor, 1.0)
	location.toggle_light(LightCommand.new(
		0, 
		'spot', 
		'center',
		Color(0.0, 0.8, 0.5, 0.9),
		0.0,
		false
	))
