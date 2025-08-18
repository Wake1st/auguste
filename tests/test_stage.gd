extends Node


@export var file_name: String

@onready var stage: Stage = $Stage


func _ready() -> void:
	Assets.load_resources()
	stage.finished.connect(_on_script_finished)
	stage.run(Assets.scripts[file_name])


func _on_script_finished() -> void:
	print("finished!!!")
