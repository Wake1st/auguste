class_name ImportListItem
extends Button


enum ImportType {
	IMAGE,
	AUDIO,
	SCRIPT,
}

signal selected(text: String, type: ImportType)

@onready var lbl_name = %LblName
@onready var lbl_type = %LblType

var asset_name: String
var asset_type: ImportType


func setup(text: String, type: ImportType) -> void:
	asset_name = text
	asset_type = type
	
	lbl_name.text = text
	
	match type:
		ImportType.IMAGE:
			lbl_type.text = "TEXTURE"
		ImportType.AUDIO:
			lbl_type.text = "AUDIO"
		ImportType.SCRIPT:
			lbl_type.text = "SCRIPT"


func _on_pressed():
	selected.emit(asset_name, asset_type)
