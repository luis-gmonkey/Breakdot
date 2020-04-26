extends Node

#const FILE_NAME = "user://game-data.json"
const FILE_NAME = "res://game-data.json"

enum { NORMAL_LEVEL, CUSTOM_LEVEL }

var game_data = {
	currentLevelId = 1,
	currentLevelArray = [],
	numberOfLevels = 10,
	levelMode = NORMAL_LEVEL
}

func save(filename, object):
	var file = File.new()
	file.open(filename, File.WRITE)
	file.store_string(to_json(object))
	file.close()

func load(filename):
	var file = File.new()
	if file.file_exists(filename):
		file.open(filename, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			game_data.currentLevelArray = data.data
		else:
			printerr("Corrupted data!")
	else:
		printerr("No saved data!")

func getCurrentLevel():
	if game_data.levelMode == NORMAL_LEVEL:
		self.load("res://Assets/Levels/level%d.json" % game_data.currentLevelId)
		
	return game_data.currentLevelArray
	
func isLastLevel():
	if game_data.numberOfLevels == game_data.currentLevelId || game_data.levelMode == CUSTOM_LEVEL:
		return true
	return false
	
func _process(delta):
	if Input.is_action_just_pressed("ui_close"):
		get_tree().quit()
