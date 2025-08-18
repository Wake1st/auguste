class_name ActorCommand
extends Command


var name: String
var texture: Texture2D


func _init(num: int, _name: String, _texture: Texture2D) -> void:
	super._init(num)
	
	name = _name
	texture = _texture
