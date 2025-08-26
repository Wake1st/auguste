class_name StepFlagColumn
extends VBoxContainer


const STEP_FLAG = preload("res://ui/editor/step_flag.tscn")

var flags: Array[StepFlag]


func create_flags(num: int) -> void:
	# clear old flags
	for child in get_children():
		if child as StepFlag:
			remove_child(child)
	flags.clear()
	
	# set new flags
	for n in range(num):
		var flag = STEP_FLAG.instantiate()
		add_child(flag)
		flags.push_back(flag)


func set_flag(line: int, type: StepFlag.Type) -> void:
	flags[line - 1].set_flag(type)
