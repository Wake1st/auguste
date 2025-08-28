class_name IDE
extends Control


signal return_selected()

@onready var director: DebugDirector = %DebugDirector

@onready var script_selector: ScriptSelector = %ScriptSelector
@onready var step_flag_column: StepFlagColumn = %StepFlagColumn
@onready var code_space: VBoxContainer = %CodeSpace
@onready var text_editor: TextEditor = %TextEditor
@onready var error_display: ErrorDisplay = %ErrorDisplay

var script_data: ScriptData
var has_unsaved_changes: bool = true
var has_passed: bool


func setup() -> void:
	script_selector.setup(
		_handle_return_selected,
		_handle_create_selected,
		_handle_script_selected
	)


func _ready() -> void:
	error_display.setup(text_editor.set_caret)
	text_editor.content_changed.connect(_handle_content_changed)
	director.finished.connect(_handle_show_finished)


func _input(event) -> void:
	if event.is_action_pressed("save"):
		# get all lines
		var lines = text_editor.get_lines()
		script_data = ScriptData.new("EMPTY", lines)
		
		_check_errors(script_data)


func _handle_return_selected() -> void:
	visible = false
	return_selected.emit()


func _handle_create_selected() -> void:
	# TODO: create an actual file
	text_editor.clear()


func _handle_script_selected(script_name: String, _type: ImportListItem.ImportType) -> void:
	var script: ScriptData = Assets.scripts[script_name]
	text_editor.text = "\n".join(script.lines)


func _handle_content_changed() -> void:
	has_unsaved_changes = true


func _handle_show_finished() -> void:
	code_space.visible = true


func _on_btn_build_pressed() -> void:
	# get all lines
	var lines = text_editor.get_lines()
	script_data = ScriptData.new("EMPTY", lines)
	has_passed = _check_errors(script_data)


func _on_btn_debug_pressed() -> void:
	if has_unsaved_changes:
		var lines = text_editor.get_lines()
		script_data = ScriptData.new("EMPTY", lines)
		has_passed = _check_errors(script_data)
	
	if has_passed:
		# run in debug mode
		step_flag_column.create_flags(text_editor.get_line_count())
		director.run(script_data)


func _on_btn_play_pressed() -> void:
	if has_unsaved_changes:
		var lines = text_editor.get_lines()
		script_data = ScriptData.new("EMPTY", lines)
		has_passed = _check_errors(script_data)
	
	if has_passed:
		# run without editor tools
		code_space.visible = false
		director.run(script_data)


func _check_errors(data: ScriptData) -> bool:
	# process lines, return errors
	var errors: Array[EditorError] = ErrorChecker.process(data)
	
	# clears errors
	error_display.clear_errors()
	
	# display error
	for error in errors:
		error_display.add_error(error)
	
	# return if any errors
	return errors.is_empty()
