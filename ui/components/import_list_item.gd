class_name ImportListItem
extends PanelContainer


enum ImportType {
	IMAGE,
	AUDIO,
	SCRIPT,
}

@onready var lbl_name = %LblName
@onready var lbl_type = %LblType


func setup(text: String, type: ImportType) -> void:
	lbl_name.text = text
	
	match type:
		ImportType.IMAGE:
			lbl_type.text = "TEXTURE"
		ImportType.AUDIO:
			lbl_type.text = "AUDIO"
		ImportType.SCRIPT:
			lbl_type.text = "SCRIPT"
