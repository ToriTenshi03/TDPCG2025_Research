extends TileMapLayer

@export var WorldLayerData:WorldLayer

var lastCellPos:Vector2i = Vector2i(-9999,-9999)
var currCellPos:Vector2i = Vector2i(-9999,-9999)

func _process(delta: float) -> void:
	currCellPos = local_to_map(get_global_mouse_position())
	_showTilePreview()
	
func _showTilePreview()->void:

	if currCellPos == lastCellPos:
		return

	set_cell(lastCellPos,1,Vector2i(0,0),-1)
	set_cell(currCellPos,1,Vector2i(0,0),WorldLayerData.IDCounter)
	lastCellPos = currCellPos


func _on_main_world_id_counter_changed(id: int) -> void:
	set_cell(currCellPos,1,Vector2i(0,0),WorldLayerData.IDCounter)
