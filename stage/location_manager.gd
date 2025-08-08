class_name LocationManager
extends Node2D


@onready var location_up_left: Location = $LocationUpLeft
@onready var location_up: Location = $LocationUp
@onready var location_up_right: Location = $LocationUpRight
@onready var location_left: Location = $LocationLeft
@onready var location_center: Location = $LocationCenter
@onready var location_right: Location = $LocationRight
@onready var location_down_left: Location = $LocationDownLeft
@onready var location_down: Location = $LocationDown
@onready var location_down_right: Location = $LocationDownRight


func setup(callable: Callable) -> void:
	location_up_left.finished.connect(callable)
	location_up.finished.connect(callable)
	location_up_right.finished.connect(callable)
	location_left.finished.connect(callable)
	location_center.finished.connect(callable)
	location_right.finished.connect(callable)
	location_down_left.finished.connect(callable)
	location_down.finished.connect(callable)
	location_down_right.finished.connect(callable)


func light_command(command: LightCommand) -> void:
	match command.location:
		Stage.Location.UP_LEFT: 
			location_up_left.toggle_light(command)
		Stage.Location.UP_CENTER: 
			location_up.toggle_light(command)
		Stage.Location.UP_RIGHT: 
			location_up_right.toggle_light(command)
		Stage.Location.LEFT: 
			location_left.toggle_light(command)
		Stage.Location.CENTER: 
			location_center.toggle_light(command)
		Stage.Location.RIGHT: 
			location_right.toggle_light(command)
		Stage.Location.DOWN_LEFT: 
			location_down_left.toggle_light(command)
		Stage.Location.DOWN_CENTER: 
			location_down.toggle_light(command)
		Stage.Location.DOWN_RIGHT: 
			location_down_right.toggle_light(command)
