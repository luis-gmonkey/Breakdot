extends Node

var current_option = 0
var last_current_option = 10
var menu_options

func _ready():
	menu_options = [$MenuOptions/level1, $MenuOptions/level2, $MenuOptions/level3, $MenuOptions/level4, $MenuOptions/level5, 
	$MenuOptions/level6, $MenuOptions/level7, $MenuOptions/level8, $MenuOptions/level9, $MenuOptions/level10]

func _process(delta):
		
	last_current_option = current_option
		
	if Input.is_action_just_pressed("ui_up"):
		$Sfx/MenuSelect.play()
		if current_option == 0:
			current_option = 9
		else:
			current_option -= 1
			
	if Input.is_action_just_pressed("ui_down"):
		$Sfx/MenuSelect.play()
		current_option = fmod(abs(current_option+1), 10)
		
	
	if Input.is_action_just_pressed("ui_accept"):
		$Sfx/MenuSelected.play()
		# A wait time so we can hear the selected sound effect before it cuts to the next scene
		
		yield(get_tree().create_timer(0.6), "timeout")
		Data.game_data.currentLevelId = current_option +1
		Data.game_data.levelMode = Data.NORMAL_LEVEL
		get_tree().change_scene("res://Scenes/Main.tscn")
		
	menu_options[last_current_option].material.set_shader_param("playing", false)
	menu_options[current_option].material.set_shader_param("playing", true)
