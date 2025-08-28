class_name ScriptSelector
extends VBoxContainer


const IMPORT_LIST_ITEM = preload("res://ui/components/import_list_item.tscn")

@onready var btn_return: Button = %BtnReturn
@onready var btn_create: Button = %BtnCreate

var selection_callable: Callable


func setup(rtn: Callable, create: Callable, selection: Callable) -> void:
	selection_callable = selection
	btn_return.pressed.connect(rtn)
	btn_create.pressed.connect(create)
	
	# list scripts
	for script in Assets.scripts.keys():
		var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
		list_item.selected.connect(selection_callable)
		add_child(list_item)
		list_item.setup(script, ImportListItem.ImportType.SCRIPT)
