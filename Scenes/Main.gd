extends Node
var Ball = preload("res://Scenes/Ball.tscn")
var Player = preload("res://Scenes/Player.tscn")
var PixelExplosion = preload("res://Scenes/PixelExplosion.tscn")

# numbers of balls you start with
var number_of_balls = 5
var time_start = 0
var elapsed_time = 0

var ball

enum { LEVEL_INIT, LEVEL_READY, PLAYING, GAME_OVER, LEVEL_CLEARED }
var game_state = LEVEL_INIT

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ingame_ui.resetUI()	
	initLevel()
	
	#Data.levels.level1 = $TileMap.tilemapToArray()
	#Data.save()

func resetBall():
	ball = Ball.instance()
	ball.connect("ball_killed", self, "_ball_killed")
	ball.connect("ball_collide", self, "_ball_collide")
	ball.init(Vector2($Player.position.x, $Player.position.y - 21))
	$Player.current_ball = ball
	add_child(ball)

# warning-ignore:unused_argument
func _process(delta):

	if game_state == PLAYING:
		if($TileMap.get_used_cells().size() == 0):
			levelCleared()
	
		run_clock()	
		if Input.is_action_pressed("ui_home"):
			$TileMap.clear()
			
		if Input.is_action_pressed("ui_accept"):
		

			if is_instance_valid($Player.current_ball):
				if $Player.current_ball.attached_to_pad:
					if($Player.position.x <= $PlayfieldArea.get_rect().size.x / 2 ):
						$Player.current_ball.startMoving($Player.current_ball.position, deg2rad(225))
					else:
						$Player.current_ball.startMoving($Player.current_ball.position, deg2rad(45))
					
func _ball_collide():
	print("Ball collide")
	var pe = PixelExplosion.instance()
	pe.position = ball.position
	add_child(pe)

func _ball_killed():
	$Sfx/DeadBall.play()
	number_of_balls-=1
	if number_of_balls <= 0:
		gameOver()
	elif game_state == PLAYING :
		resetBall()
		
	$Ingame_ui.setNumberOfBalls(number_of_balls)

func _input(event):
	if event is InputEventMouseButton:
		var pos = event.position
		if event.pressed:
			print("Mouse Click at: ", pos)
			var tilemap = $TileMap
			var tile_pos = tilemap.world_to_map(pos)
			var cell = tilemap.get_cellv(tile_pos)
			# if cell == 3: # thetilesets tile id
			#   tilemap.set_cellv(tile_pos, 4)
			print("Tile pos ", tile_pos)
			print("cell: ", cell)

		else:
			print("Mouse Unclick at: ", pos)

func run_clock():
	if(game_state == PLAYING):
		var time_now = OS.get_unix_time()
		var elapsed = time_now - time_start
		var minutes = elapsed / 60
		var seconds = elapsed % 60
		elapsed_time = "%02d : %02d" % [minutes, seconds]
		$Ingame_ui.setTime(elapsed_time)

func gameOver():
	game_state = GAME_OVER
	number_of_balls = 0
	get_tree().change_scene("res://Scenes/GameOver.tscn")

func initLevel():
	$Sfx/Music.play()
	# countdown
	yield(get_tree().create_timer(1), "timeout")
	
	$TileMap.arrayToTilemap(Data.getCurrentLevel())
	add_child(Player.instance())
	time_start = OS.get_unix_time()
	$Ingame_ui.resetUI()
	$Ingame_ui.setNumberOfBalls(5)
	resetBall()
	game_state = PLAYING

func levelCleared():
	$Sfx/Win.play()
	game_state = LEVEL_CLEARED
	
	remove_child($Player)
	remove_child(ball)
	$Ingame_ui.levelCleared(elapsed_time)
	$Sfx/Music.stop()
	yield(get_tree().create_timer(4.0), "timeout")
	$Sfx/Win.stop()
	goToNextLevel()

func goToNextLevel():
	if Data.game_data.levelMode == Data.CUSTOM_LEVEL:
		get_tree().change_scene("res://Scenes/LevelEditor.tscn")
	
	elif Data.isLastLevel():
		get_tree().change_scene("res://Scenes/Finished.tscn")
		pass
	else:
		Data.game_data.currentLevelId += 1;
		initLevel()
	
