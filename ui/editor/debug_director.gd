class_name DebugDirector
extends Director


@export var flag_column: StepFlagColumn
@export var text_editor: TextEditor

@onready var breakpoint_exit: BreakpointExit = $BreakpointExit


func _ready() -> void:
	stage.setup(_handle_command_finished)
	stage.delay_complete.connect(_handle_delay_complete)


func _next_command() -> void:
	# increment and check for end of command
	command_index += 1
	if command_index >= commands.size():
		finished.emit()
		return
	
	# process the new command
	var command = commands[command_index]
	
	# first, check for breakpoint to pause
	if text_editor.is_line_breakpointed(command.line_number - 1):
		flag_column.set_flag(command.line_number, StepFlag.Type.STOP)
		await breakpoint_exit.continued
	
	# delayed commands will be bound to a timer
	if command.has_delay():
		flag_column.set_flag(command.line_number, StepFlag.Type.WAIT)
		stage.delay_command(command)
		_next_command()
	else:
		flag_column.set_flag(command.line_number, StepFlag.Type.ON)
		stage.run(command)


func _handle_delay_complete(line_number: int) -> void:
	flag_column.set_flag(line_number, StepFlag.Type.ON)


func _handle_command_finished(wasDelayed: bool = false, waitTime: float = -1.0) -> void:
	if waitTime > 0.0:
		await stage.force_wait(waitTime)
	
	if not wasDelayed:
		_next_command()
