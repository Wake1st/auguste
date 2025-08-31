class_name IDE
extends Control


signal return_selected()

@onready var director: DebugDirector = $DebugDirector
@onready var new_script_window: NewScriptWindow = $NewScriptWindow
@onready var deletion_confirmation: ScriptDeletionConfirmation = $ScriptDeletionConfirmation

@onready var script_selector: ScriptSelector = %ScriptSelector
@onready var step_flag_column: StepFlagColumn = %StepFlagColumn
@onready var code_space: VBoxContainer = %CodeSpace
@onready var text_editor: TextEditor = %TextEditor
@onready var error_display: ErrorDisplay = %ErrorDisplay
@onready var sub_viewport_container: SubViewportContainer = %SubViewportContainer
@onready var stage: Stage = %Stage

var script_data: ScriptData
var has_unsaved_changes: bool = true
var has_passed: bool


func setup() -> void:
	script_selector.setup(
		_handle_script_selected,
		_handle_return_selected,
		_handle_create_selected,
		_handle_save_selected,
		_handle_delete_selected
	)
	script_selector.refresh()


func _ready() -> void:
	error_display.setup(text_editor.set_caret)
	text_editor.content_changed.connect(_handle_content_changed)
	director.finished.connect(_handle_show_finished)
	
	new_script_window.close_requested.connect(_handle_close_requested)
	new_script_window.script_created.connect(_handle_creation_confirmed)
	
	deletion_confirmation.close_requested.connect(_handle_close_requested)
	deletion_confirmation.confirmed.connect(_handle_delete_confirmed)


func _input(event) -> void:
	if event.is_action_pressed("save"):
		# get all lines
		script_data.lines = text_editor.get_lines()
		
		# save file
		Assets.save_script(script_data)
		
		# return syntax errors
		_check_errors(script_data)


#region SelectionHandlers
func _handle_return_selected() -> void:
	visible = false
	return_selected.emit()


func _handle_create_selected() -> void:
	new_script_window.show()


func _handle_creation_confirmed(filename: String) -> void:
	# create an actual file and update local data
	Assets.create_script(filename)
	script_data = ScriptData.new(filename, [])
	
	# ui updates
	script_selector.refresh()
	text_editor.clear()


func _handle_close_requested() -> void:
	new_script_window.hide()
	new_script_window.clear()
	deletion_confirmation.hide()


func _handle_save_selected() -> void:
	script_data.lines = text_editor.get_lines()
	Assets.save_script(script_data)


func _handle_delete_selected() -> void:
	deletion_confirmation.request(script_data.name)


func _handle_delete_confirmed() -> void:
	Assets.delete_script(script_data.name)
	text_editor.clear()
	script_selector.refresh()


func _handle_script_selected(script_name: String, _type: ImportListItem.ImportType) -> void:
	script_data = Assets.scripts[script_name]
	text_editor.text = "\n".join(script_data.lines)


func _handle_content_changed() -> void:
	has_unsaved_changes = true


func _handle_show_finished() -> void:
	code_space.visible = true
	script_selector.visible = true
	sub_viewport_container.visible = false
#endregion

#region EditorHandlers
func _on_btn_build_pressed() -> void:
	if script_data == null:
		script_data = ScriptData.new("DEMO", [])
	
	# get all lines
	script_data.lines = text_editor.get_lines()
	has_passed = _check_errors(script_data)


func _on_btn_debug_pressed() -> void:
	if script_data == null:
		script_data = ScriptData.new("DEMO", [])
	
	if has_unsaved_changes:
		script_data.lines = text_editor.get_lines()
		has_passed = _check_errors(script_data)
	
	if has_passed:
		# change UI
		script_selector.visible = false
		sub_viewport_container.visible = true
		
		# run in debug mode
		step_flag_column.create_flags(text_editor.get_line_count())
		director.run(script_data)


func _on_btn_play_pressed() -> void:
	if script_data == null:
		script_data = ScriptData.new("DEMO", [])
	
	if has_unsaved_changes:
		script_data.lines = text_editor.get_lines()
		has_passed = _check_errors(script_data)
	
	if has_passed:
		# change UI
		script_selector.visible = false
		code_space.visible = false
		sub_viewport_container.visible = true
		
		# run without editor tools
		step_flag_column.create_flags(text_editor.get_line_count())
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
#endregion
