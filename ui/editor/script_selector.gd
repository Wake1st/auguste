class_name ScriptSelector
extends VBoxContainer


const IMPORT_LIST_ITEM = preload("res://ui/components/import_list_item.tscn")

@onready var btn_return: Button = %BtnReturn
@onready var btn_create: Button = %BtnCreate
@onready var btn_save: Button = %BtnSave
@onready var btn_delete: Button = %BtnDelete

var selection_callable: Callable


func setup(
	selection: Callable, 
	rtn: Callable, 
	create: Callable,
	save: Callable,
	delete: Callable
) -> void:
	selection_callable = selection
	btn_return.pressed.connect(rtn)
	btn_create.pressed.connect(create)
	btn_save.pressed.connect(save)
	btn_delete.pressed.connect(delete)


func refresh() -> void:
	# clear away existing entries
	for listing in get_tree().get_nodes_in_group("script_listing"):
		remove_child(listing)
		listing.queue_free()
	
	# list scripts
	for script in Assets.scripts.keys():
		var list_item: ImportListItem = IMPORT_LIST_ITEM.instantiate()
		list_item.selected.connect(selection_callable)
		list_item.add_to_group("script_listing")
		add_child(list_item)
		list_item.setup(script, ImportListItem.ImportType.SCRIPT)
