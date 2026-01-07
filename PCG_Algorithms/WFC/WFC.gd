class_name  WaveFunctionCollapse
extends Node

const UP:Vector2i = Vector2i.UP
const DOWN:Vector2i  = Vector2i.DOWN
const LEFT:Vector2i  = Vector2i.LEFT
const RIGHT:Vector2i  = Vector2i.RIGHT

@export_category("Grid Settings")
@export var world_layer:TileMapLayer
@export var grid_size:Vector2i = Vector2i(10,10)

var tiles:Array[int] = [1,2,3,4,5,6,7,8,9,10,11]

var DIRECTIONS:Array[Vector2i] = [UP,DOWN,LEFT,RIGHT]

var rules:Dictionary = {
	1:
	{
		UP:  0,
		DOWN: 1,  
		LEFT: 2, 
		RIGHT: 0,
	},
	2:
	{
		UP:    0,
		DOWN:  1,
		LEFT:  0,
		RIGHT: 2,
	},
	3:
	{
		UP:    1,
		DOWN:  0,
		LEFT:  0,
		RIGHT: 2,
	},
	4:
	{
		UP:    1,
		DOWN:  0,
		LEFT:  2,
		RIGHT: 0,
	},
	5:
	{
		UP:    0,
		DOWN:  0,
		LEFT:  2,
		RIGHT: 2,
	},
	6:
	{
		UP:    1,
		DOWN:  1,
		LEFT:  0,
		RIGHT: 0,
	},
	7:
	{
		UP:    0,
		DOWN:  0,
		LEFT:  0,
		RIGHT: 2,
	},
	8:
	{
		UP:    0,
		DOWN:  0,
		LEFT:  2,
		RIGHT: 0,
	},
	9:
	{
		UP:    0,
		DOWN:  1,
		LEFT:  0,
		RIGHT: 0,
	},
	10:
	{
		UP:    1,
		DOWN:  0,
		LEFT:  0,
		RIGHT: 0,
	},
	11:
	{
		UP:    0,
		DOWN:  0,
		LEFT:  0,
		RIGHT: 0,
	},
}

var grid:Array = []

var wfc_started:bool
var finished:bool

func init_grid()->void:
	grid.clear()
	for y in range(grid_size.y):
		var row:Array = []
		for x in range(grid_size.x):
			row.append(tiles.duplicate())
		grid.append(row)

func get_lowest_entropy_cell()->Vector2i:
	var lowest:Vector2i = Vector2i(-1,-1)
	var bestEntropy:int = 999999

	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var options = grid[y][x]
			if options.size() > 1 and options.size() < bestEntropy:
				bestEntropy = options.size()
				lowest= Vector2i(x,y)
	return lowest

func collapse_cell(pos:Vector2i):
	var options = grid[pos.y][pos.x]
	grid[pos.y][pos.x] = [options.pick_random()]


func propagate(start:Vector2i):
	var stack = [start]

	while !stack.is_empty():
		var current = stack.pop_back()
		var current_tiles = grid[current.y][current.x]

		for dir in DIRECTIONS:
			var neighbour = current+dir
			if !in_bounds(neighbour):
				continue
				
			var neighbour_options = grid[neighbour.y][neighbour.x]
			var allowed = []

			for tile_index in current_tiles:
				for candidate_tile in tiles:
					var opp_dir = opposite(dir)
					if rules[tile_index][dir] == rules[candidate_tile][opp_dir]:
						allowed.append(candidate_tile)

			allowed = allowed.duplicate().filter(func(i): return i in allowed)

	
			if allowed.is_empty():
				push_error("WFC contradiction at cell %s!" % [neighbour])
				finished = true
				return

			if allowed.size() < neighbour_options.size():
				grid[neighbour.y][neighbour.x] = allowed
				stack.append(neighbour)



func opposite(dir: Vector2i) -> Vector2i:
	if dir == UP: return DOWN
	if dir == DOWN: return UP
	if dir == LEFT: return RIGHT
	if dir == RIGHT: return LEFT
	return Vector2i.ZERO

func in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.y >= 0 and pos.x < grid_size.x and pos.y < grid_size.y

func start_wfc():
	init_grid()        # reset the grid
	wfc_started = true
	finished = false
	print("WFC started")

func run_wfc():
	var cell := get_lowest_entropy_cell()
	
	# If all cells collapsed, finish
	if cell.x == -1:
		finished = true
		print("WFC finished!")
		return

	print("Collapsing cell:", cell, "Options:", grid[cell.y][cell.x])
	collapse_cell(cell)
	propagate(cell)
	display_wfc_result()

func _process(delta: float) -> void:
	if wfc_started and not finished:
		run_wfc()


func display_wfc_result():
	world_layer.clear()
	for y in grid_size.y:
		for x in grid_size.x:
			var tileCoords = Vector2i(x,y)
			var tile_index = grid[y][x][0]
			world_layer.set_cell(tileCoords,1,Vector2i(0,0),tile_index)
