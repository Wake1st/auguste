class_name DisplayContainer
extends Container


const AUDIO_DISPLAY = preload("res://ui/components/audio_display.tscn")
const TEXT_EDITOR = preload("res://ui/editor/text_editor.tscn")

var current_display: Control


func display_texture(texture: Texture2D) -> void:
	if current_display:
		remove_child(current_display)
	
	var display: TextureRect = TextureRect.new()
	display.texture = texture
	add_child(display)
	current_display = display


func display_audio(stream: AudioStream) -> void:
	if current_display:
		remove_child(current_display)
	
	var display: AudioDisplay = AUDIO_DISPLAY.instantiate()
	add_child(display)
	display.add(stream)
	current_display = display


func display_script(script: ScriptData) -> void:
	if current_display:
		remove_child(current_display)
	
	var display: TextEditor = TEXT_EDITOR.instantiate()
	display.text = "\n".join(script.lines as PackedStringArray)
	display.editable = false
	add_child(display)
	current_display = display
