class_name TextEditor
extends CodeEdit


signal content_changed()

const ACTION_COLOR: Color = Color("ff6c4f")
const COMMENT_COLOR: Color = Color("8c8f9c")
const FLAG_COLOR: Color = Color("91b5ff")
const NUMBER_COLOR: Color = Color("f636e5")
const SINGLE_QUOTE_COLOR: Color = Color("07f787")
const DOUBLE_QUOTE_COLOR: Color = Color("b7f707")
const FUNC_COLOR: Color = Color("7f1fed")
const KEYWORD_COLOR: Color = Color("f2740c")


func set_caret(location: Vector2) -> void:
	set_caret_line(location.y)
	set_caret_column(location.x)


func get_lines() -> Array[String]:
	var lines: Array[String]
	for line in text.split("\n"):
		lines.push_back(line)
	return lines


func _ready() -> void:
	var highlighter: CodeHighlighter = CodeHighlighter.new()
	
	# comments and strings
	highlighter.add_color_region("#", "", COMMENT_COLOR, true)
	highlighter.add_color_region("'", "'", SINGLE_QUOTE_COLOR)
	highlighter.add_color_region("\"", "\"", DOUBLE_QUOTE_COLOR)
	
	# actions
	highlighter.add_keyword_color("scene", ACTION_COLOR)
	highlighter.add_keyword_color("actor", ACTION_COLOR)
	highlighter.add_keyword_color("wait", ACTION_COLOR)
	highlighter.add_keyword_color("light", ACTION_COLOR)
	highlighter.add_keyword_color("sound", ACTION_COLOR)
	highlighter.add_keyword_color("narate", ACTION_COLOR)
	highlighter.add_keyword_color("speak", ACTION_COLOR)
	highlighter.add_keyword_color("enter", ACTION_COLOR)
	highlighter.add_keyword_color("exit", ACTION_COLOR)
	highlighter.add_keyword_color("move", ACTION_COLOR)
	highlighter.add_keyword_color("animate", ACTION_COLOR)
	
	# keywords
	highlighter.add_keyword_color("up", KEYWORD_COLOR)
	highlighter.add_keyword_color("down", KEYWORD_COLOR)
	highlighter.add_keyword_color("left", KEYWORD_COLOR)
	highlighter.add_keyword_color("right", KEYWORD_COLOR)
	highlighter.add_keyword_color("center", KEYWORD_COLOR)
	highlighter.add_keyword_color("above", KEYWORD_COLOR)
	highlighter.add_keyword_color("below", KEYWORD_COLOR)
	highlighter.add_keyword_color("spot", KEYWORD_COLOR)
	
	# optional flags
	highlighter.symbol_color = FLAG_COLOR
	highlighter.add_keyword_color("d", FLAG_COLOR)
	highlighter.add_keyword_color("t", FLAG_COLOR)
	highlighter.add_keyword_color("o", FLAG_COLOR)
	highlighter.add_keyword_color("p", FLAG_COLOR)
	highlighter.add_keyword_color("b", FLAG_COLOR)
	highlighter.add_keyword_color("s", FLAG_COLOR)
	highlighter.add_keyword_color("c", FLAG_COLOR)
	highlighter.add_keyword_color("v", FLAG_COLOR)
	highlighter.add_keyword_color("dr", FLAG_COLOR)
	highlighter.add_keyword_color("l", FLAG_COLOR)
	highlighter.add_keyword_color("w", FLAG_COLOR)
	
	# numbers
	highlighter.number_color = NUMBER_COLOR
	
	# functions
	highlighter.function_color = FUNC_COLOR
	highlighter.add_member_keyword_color("(", FUNC_COLOR)
	highlighter.add_member_keyword_color(")", FUNC_COLOR)
	highlighter.add_member_keyword_color(",", FUNC_COLOR)
	
	syntax_highlighter = highlighter


func _on_breakpoint_toggled(line):
	pass # Replace with function body.

func _on_code_completion_requested():
	pass # Replace with function body.

func _on_symbol_hovered(symbol, line, column):
	pass # Replace with function body.

func _on_symbol_lookup(symbol, line, column):
	pass # Replace with function body.

func _on_symbol_validate(symbol):
	pass # Replace with function body.

func _on_caret_changed():
	pass # Replace with function body.

func _on_lines_edited_from(from_line, to_line):
	pass # Replace with function body.

func _on_text_changed() -> void:
	content_changed.emit()

func _on_text_set() -> void:
	content_changed.emit()
