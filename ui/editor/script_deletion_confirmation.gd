class_name ScriptDeletionConfirmation
extends Window


signal confirmed()

@onready var script_name: Label = %ScriptName


func request(script: String) -> void:
	script_name.text = script
	show()


func _on_btn_cancel_pressed():
	close_requested.emit()


func _on_btn_confirm_pressed():
	confirmed.emit()
	close_requested.emit()
