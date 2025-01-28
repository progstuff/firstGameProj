extends TileMapLayer

var tileMap = {}
@export var mapCenter = Vector2.ZERO
@export var playerCoords = Vector2.ZERO
@export var playState = false

var CHUNK_WIDTH = 1000
var CHUNK_HEIGHT = 800

var BORDER_X = 400
var BORDER_Y = 300

var CELL_WIDTH = 16
var CELL_HEIGHT = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(playState):
		var coords = playerCoords
		var i = floor(coords.x/CHUNK_WIDTH)
		var j = floor(coords.y/CHUNK_HEIGHT)
		
		generateTerrain(i,j)
		
		var startX = CHUNK_WIDTH*i
		var endX = CHUNK_WIDTH*(i+1)
		var startY = CHUNK_HEIGHT*j
		var endY = CHUNK_HEIGHT*(j+1)
		
		var borderLeft = startX + BORDER_X
		var borderRight = endX - BORDER_X
		var borderUp = endY - BORDER_Y
		var borderDn = startY + BORDER_Y
		
		if(coords.x < borderLeft):
			generateTerrain(i-1,j)
		elif (coords.x > borderRight):
			generateTerrain(i+1,j)
		
		if(coords.y > borderUp):
			generateTerrain(i,j+1)
		elif(coords.y < borderDn):
			generateTerrain(i,j-1)
		
		if(coords.x < borderLeft):
			if(coords.y > borderUp):
				generateTerrain(i-1,j+1)
			elif(coords.y < borderDn):
				generateTerrain(i-1,j-1)
		elif (coords.x > borderRight):
			if(coords.y > borderUp):
				generateTerrain(i+1,j+1)
			elif(coords.y < borderDn):
				generateTerrain(i+1,j-1)
				

func generateTerrain(i: int, j: int) -> void:
	var chunkCoord = Vector2(i, j)

	
	if(!tileMap.has(chunkCoord)):
		tileMap[chunkCoord] = true
		var startX = CHUNK_WIDTH*i
		var endX = CHUNK_WIDTH*(i+1)
		var startY = CHUNK_HEIGHT*j
		var endY = CHUNK_HEIGHT*(j+1)
		
		for x in range(startX, endX, CELL_WIDTH):

			for y in range(startY, endY, CELL_HEIGHT):
				set_cell(local_to_map(Vector2(x, y)), 0, Vector2i(12, 0))
		print("create", Vector2(i, j))
