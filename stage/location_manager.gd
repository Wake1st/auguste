class_name LocationManager
extends Node2D


@export var above_stage: Marker2D
@export var below_stage: Marker2D
@export var left_stage: Marker2D
@export var right_stage: Marker2D

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
	var location: Location = get_location(command.location)
	location.toggle_light(command)


func send_actor(actor: Actor, command: ActorMoveCommand) -> void:
	var location: Location = get_location(command.location)
	location.send_actor(actor, command.duration)


func enter_actor(actor: Actor, command: ActorEnterCommand) -> void:
	# get the target location
	var location: Location = get_location(command.location)
	
	# get the off stage position
	var out_position: Vector2
	match command.direction:
		Stage.Direction.BELOW:
			out_position += Vector2(location.x, below_stage.y)
		Stage.Direction.ABOVE:
			out_position += Vector2(location.x, above_stage.y)
		Stage.Direction.LEFT:
			out_position += Vector2(left_stage.x, location.y)
		Stage.Direction.RIGHT:
			out_position += Vector2(right_stage.x, location.y)
	
	# move the actor from off stage to the location
	location.enter_actor(actor, command.duration, out_position)



func exit_actor(actor: Actor, command: ActorExitCommand) -> void:
	# get the target location
	var location: Location = get_location(command.location)
	
	# get the off stage position
	var out_position: Vector2
	match command.direction:
		Stage.Direction.BELOW:
			out_position += Vector2(location.x, below_stage.y)
		Stage.Direction.ABOVE:
			out_position += Vector2(location.x, above_stage.y)
		Stage.Direction.LEFT:
			out_position += Vector2(left_stage.x, location.y)
		Stage.Direction.RIGHT:
			out_position += Vector2(right_stage.x, location.y)
	
	# move the actor from off stage to the location
	location.exit_actor(actor, command.duration, out_position)


func get_location(location: Stage.Location) -> Location:
	match location:
		Stage.Location.UP_LEFT: 
			return location_up_left
		Stage.Location.UP_CENTER: 
			return location_up
		Stage.Location.UP_RIGHT: 
			return location_up_right
		Stage.Location.LEFT: 
			return location_left
		Stage.Location.CENTER: 
			return location_center
		Stage.Location.RIGHT: 
			return location_right
		Stage.Location.DOWN_LEFT: 
			return location_down_left
		Stage.Location.DOWN_CENTER: 
			return location_down
		Stage.Location.DOWN_RIGHT: 
			return location_down_right
		_:
			return null
