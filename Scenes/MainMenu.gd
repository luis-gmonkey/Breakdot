extends Node2D

enum { PLAY, LOAD_LEVEL, LEVEL_EDITOR, EXIT }

var menu_options

var current_option = PLAY
var last_current_optiom = EXIT

func _ready():
	menu_options = [$MenuOptions/play, $MenuOptions/load_level, $MenuOptions/level_editor, $MenuOptions/exit]
	#$MenuOptions/play.material.set_shader_param("playing", true)

func _process(delta):
	

	last_current_optiom = current_option
	
	if Input.is_action_just_pressed("ui_up"):
		$Sfx/MenuSelect.play()
		if current_option == 0:
			current_option = 3
		else:
			current_option -= 1

		
		
	if Input.is_action_just_pressed("ui_down"):
		$Sfx/MenuSelect.play()
		current_option = fmod(abs(current_option+1), 4)
	
	menu_options[last_current_optiom].material.set_shader_param("playing", false)
	menu_options[current_option].material.set_shader_param("playing", true)
	
	if Input.is_action_just_pressed("ui_accept"):
		if(current_option == PLAY):
			$Sfx/MenuSelected.play()
			# A wait time so we can hear the selected sound effect before it cuts to the next scene
			yield(get_tree().create_timer(0.6), "timeout")
			Data.game_data.levelMode = Data.NORMAL_LEVEL
			Data.game_data.currentLevelId = 1
			get_tree().change_scene("res://Scenes/Main.tscn")
			
		if(current_option == LOAD_LEVEL):
			$Sfx/MenuSelected.play()
			# A wait time so we can hear the selected sound effect before it cuts to the next scene
			yield(get_tree().create_timer(0.6), "timeout")
			get_tree().change_scene("res://Scenes/ChooseLevel.tscn")
			
		if(current_option == LEVEL_EDITOR):
			$Sfx/MenuSelected.play()
			# A wait time so we can hear the selected sound effect before it cuts to the next scene
			yield(get_tree().create_timer(0.6), "timeout")
			get_tree().change_scene("res://Scenes/LevelEditor.tscn")
			
		if(current_option == EXIT):
			$Sfx/MenuSelected.play()
			# A wait time so we can hear the selected sound effect before it cuts to the next scene
			yield(get_tree().create_timer(0.6), "timeout")
			get_tree().quit()
		
		

	
