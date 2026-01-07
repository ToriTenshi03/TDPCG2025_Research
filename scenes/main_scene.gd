class_name WorldLayer
extends TileMapLayer

var IDCounter:int = 1
var maxIDCounter:int = 2

signal IDCounterChanged(id:int)

func _input(event: InputEvent) -> void:
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
