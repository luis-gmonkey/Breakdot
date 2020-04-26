extends KinematicBody2D

signal ball_killed
signal ball_collide

export var speed = 400
# Is the ball attached to the pad ?
export var attached_to_pad = true
var player
var velocity = Vector2()
var collision_radius
var screen_size
var playfield_area # a rect that defines the limits of the playfield
var tilemap
var draw_start= Vector2()
var draw_end= Vector2()

func _ready():
	tilemap = get_parent().get_node("TileMap")
	player = get_parent().get_node("Player")
	playfield_area = get_parent().get_node("PlayfieldArea").get_rect()
	collision_radius = $CollisionShape2D.shape.radius
	screen_size = get_viewport_rect().size
	# disable collisionshape so the ball can stand still
	$CollisionShape2D.set_deferred("disabled", true)
	


func init(start_position, attached = true):
	attached_to_pad = attached
	position = start_position
	pass

func startMoving(pos, dir):
	rotation = dir
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)
	attached_to_pad = false
	$CollisionShape2D.set_deferred("disabled", false)
	


func _physics_process(delta):
	
	if not attached_to_pad:
		
		var collision = move_and_collide(velocity * delta)
	
		if collision:
			
			if collision.collider is TileMap:
				# gets the collision normal
				var normal = collision.normal
				# gets the tile position acording to worldposition
				var tile_position = collision.collider.world_to_map(collision.collider.to_local(position))
				
				# fix the normals so always gets a tile, because sometimes we were getting the adjacent empty tile
				var new_normal = Vector2(ceil(abs(normal.x))*sign(normal.x), ceil(abs(normal.y))*sign(normal.y))
				
							
				# substracts the normal from the tile position to get the correct position
				var new_tile_position = tile_position - new_normal
				
				# its unlikely that I need these because the normal already comes with int precision
				#tile_position = Vector2(int(tile_position.x), int(tile_position.y))
			
				var tile = collision.collider.get_cellv(new_tile_position)
				
				# checks if exists any tile here, -1 means no tile
				if(tile >= 0):
						
					#var tile_name = collision.collider.tile_set.tile_get_name(tile)
					
					tile = handleTilesParty(tile)
													
					collision.collider.set_cellv(new_tile_position, tile)

					emit_signal("ball_collide")
					bounceBall(collision.normal, collision.position)
					
				else:
					print("Error: Empty tile" + str(new_tile_position))
					pass
					
			if collision.collider.name == "Player":
				bounceBall(collision.normal)	
			
	else:
		position.x = player.position.x
			
		#if collision.collider.has_method("hit"):
			#collision.collider.hit()
			
	# when the ball gets outside the screen, emits a signal saying that the ball is "dead# x.x		
	if position.y > screen_size.y:
		emit_signal("ball_killed")
		queue_free()

	#bounces ball from the screen limits, no need for this if we use tiles to make a barrier
	if (position.y + (collision_radius) >= playfield_area.size.y || position.y - (collision_radius) <= playfield_area.position.y):
		$Sfx/BounceEffect.play()
		velocity = velocity.bounce(Vector2(0,1))
		
	if (position.x + (collision_radius) >= playfield_area.size.x || position.x - (collision_radius) <= playfield_area.position.x):
		$Sfx/BounceEffect.play()
		velocity = velocity.bounce(Vector2(1,0))

# bounces ball based on the normal parameter
func bounceBall(normal, tp = Vector2() ):
	$Sfx/BounceEffect.play()

	if( (int(normal.x) != normal.x) || (int(normal.y) != normal.y)):
		normal = Vector2(0, sign(position.y))
		#print("Get fucked")
		
	velocity = velocity.bounce(normal)

func getTile(collidedTile, tileFamily):
	
	var index = 0
	var next_tile = -1
	
	for i in tileFamily.size():
		if(tileFamily.tiles[i] == collidedTile && (i+1) < tileFamily.tiles.size()):
			next_tile = tileFamily.tiles[i+1]

	return next_tile
	
# temp func, change name and get a better way to handle this	
func handleTilesParty(tile):
	var final_tile = -1
	
	if( tile in tilemap.headBricks.tiles):
		final_tile = getTile(tile, tilemap.headBricks)
	elif( tile in tilemap.sandStoneBricks.tiles):
		final_tile = getTile(tile, tilemap.sandStoneBricks)
	elif( tile in tilemap.stoneBricks.tiles):
		final_tile = getTile(tile, tilemap.stoneBricks)
	elif( tile in tilemap.faceBricks.tiles):
		final_tile = getTile(tile, tilemap.faceBricks)
	elif( tile in tilemap.stoneBricks2.tiles):
		final_tile = getTile(tile, tilemap.stoneBricks2)
	else:
		print("Normal tile")

	
	return final_tile

