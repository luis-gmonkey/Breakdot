extends Node2D

# declare if its painting or not so we can display the mouse cursor or not
var is_painting = true

var current_tile = 0
var mouse_pos = Vector2()
var tile_pos = Vector2()

func _ready():
	$MenuButton.get_popup().connect("id_pressed", self, "_on_item_pressed")
	
	$WorkingTile.texture = $TileMap.tile_set.tile_get_texture(0)	
	$WorkingTile.region_rect = $TileMap.tile_set.tile_get_region(current_tile)
	$WorkingTile.region_enabled = true
	
	if Data.game_data.currentLevelArray.size() > 0:
		 $TileMap.arrayToTilemap(Data.game_data.currentLevelArray)
	
	pass # Replace with function body.

func _process(delta):
	$WorkingTile.position = mouse_pos
	$WorkingTile.region_rect = $TileMap.tile_set.tile_get_region(current_tile)
		
func _input(event):
	
	if event is InputEventMouseMotion:
		mouse_pos = event.position

		tile_pos = $TileMap.world_to_map(mouse_pos)		

		if tile_pos.y > 16:
			setTileToolVisible(false)
		elif $FileDialog.visible == false:
			setTileToolVisible(true)

		
	if event.is_action_pressed("tile_down"):
		current_tile = (current_tile +1) % 43
			
	if event.is_action_pressed("tile_up"):
		if(current_tile == 0):
			current_tile = 42
		else:
			current_tile = (current_tile -1)
		
	if event is InputEventMouseButton:
		if event.pressed:
			
							
			if is_painting:
				if event.button_index == BUTTON_LEFT:
					if event.pressed:
						$TileMap.set_cellv(tile_pos, current_tile)
						
				if event.button_index == BUTTON_RIGHT:
					$TileMap.set_cellv(tile_pos, -1)
			
	
	
func _on_item_pressed(id):
	if id == 0:
		$FileDialog.mode = $FileDialog.MODE_OPEN_FILE
	elif id == 1:
		$FileDialog.mode = $FileDialog.MODE_SAVE_FILE 
		
	$FileDialog.visible = true

func _on_FileDialog_file_selected(path):
	
	if $FileDialog.mode == $FileDialog.MODE_SAVE_FILE:
		var level = {
			data = $TileMap.tilemapToArray()
		}
		Data.save(path, level)
	elif $FileDialog.mode == $FileDialog.MODE_OPEN_FILE:
		Data.load(path)
		$TileMap.arrayToTilemap(Data.game_data.currentLevelArray)
		pass # Replace with function body.


func _on_FileDialog_visibility_changed():
	
	if $FileDialog.visible:
		setTileToolVisible(false)
	else:
		setTileToolVisible(false)
		
func setTileToolVisible(visible):
	
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	is_painting = visible
	$WorkingTile.visible = visible


func _on_Exit_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")


func _on_Play_pressed():
	Data.game_data.levelMode = Data.CUSTOM_LEVEL
	Data.game_data.currentLevelArray = $TileMap.tilemapToArray()
	get_tree().change_scene("res://Scenes/Main.tscn")
