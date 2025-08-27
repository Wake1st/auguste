class_name StepFlag
extends TextureRect


enum Type {
	OFF,
	ON,
	WAIT,
	STOP,
}

const LIGHT_BASE = preload("res://assets/images/light_base.png")
const LIGHT_GO = preload("res://assets/images/light_go.png")
const LIGHT_WAIT = preload("res://assets/images/light_wait.png")
const LIGHT_STOP = preload("res://assets/images/light_stop.png")


func set_flag(type: Type) -> void:
	match type:
		Type.OFF:
			texture = LIGHT_BASE
		Type.ON:
			texture = LIGHT_GO
		Type.WAIT:
			texture = LIGHT_WAIT
		Type.STOP:
			texture = LIGHT_STOP
