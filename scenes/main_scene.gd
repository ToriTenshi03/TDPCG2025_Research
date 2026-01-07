class_name WorldLayer
extends TileMapLayer

@export_category("User Inputs")
@export var isInteractable:bool = false

@export_category("PCG Algorithms")
@export var WFC:Node

var IDCounter:int = 1
var maxIDCounter:int = -1


signal IDCounterChanged(id:int)

func _init() -> void:
	_setMaxTiles()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_B and event.pressed:
			isInteractable = !isInteractable
		
		if event.keycode == KEY_ENTER and event.pressed:
			WFC.start_wfc()
			
			

	if !isInteractable:
		return

	_placeAndDestroyTiles(event)


func _placeAndDestroyTiles(event: InputEvent)-> void:
	var tileCoords = local_to_map(get_global_mouse_position())
	if event is InputEventKey:
		if event.keycode == KEY_TAB and event.pressed:
			IDCounter = (IDCounter%maxIDCounter) + 1
			emit_signal("IDCounterChanged",IDCounter)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			set_cell(tileCoords,1,Vector2i(0,0),IDCounter)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			set_cell(tileCoords,1,Vector2i(0,0),-1)

func _setMaxTiles():
	set_cell(Vector2i(0,0),1,Vector2i(0,0),1)
	var source_id = get_cell_source_id(Vector2i(0, 0))
	if source_id > -1:
		var scene_source = tile_set.get_source(source_id)
		maxIDCounter = scene_source.get_scene_tiles_count()
	erase_cell(Vector2i(0,0))
