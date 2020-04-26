extends TileMap

var sandStoneBricks = {
	tiles = [12, 8]
}

var headBricks = {
	tiles = [15, 16, 17, 18]
}

var stoneBricks = {
	tiles = [28, 29, 30]
}

var faceBricks = {
	tiles = [36, 37]
}

var stoneBricks2 = {
	tiles = [20, 19]
}

var height = 32
var width = 32

func tilemapToArray():
	var tmp_map = create_2d_array(32, 32, -1)
	
	for y in range(height):
		for x in range(width):
			tmp_map[y][x] = self.get_cell(x, y)
	
	return tmp_map
	
func arrayToTilemap(array):
	for y in range(height):
		for x in range(width):
			self.set_cell(x, y, array[y][x])
	

	
func create_2d_array(width, height, value):
	var a = []

	for y in range(height):
		a.append([])
		a[y].resize(width)

		for x in range(width):
			a[y][x] = value

	return a




