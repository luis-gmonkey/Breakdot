extends KinematicBody2D


export var speed = 700
export var current_ball = 0
var playfield_area 


# Called when the node enters the scene tree for the first time.
func _ready():
	playfield_area = get_parent().get_node("PlayfieldArea").get_rect()
	position.x = playfield_area.size.x / 2
	position.y = 570

func _physics_process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		if(position.x + ($CollisionShape2D.shape.extents.x + 20) > playfield_area.size.x):
			velocity.x = 0
		else:
			velocity.x += 1
			
	if Input.is_action_pressed("ui_left"):
		if(position.x - ($CollisionShape2D.shape.extents.x + 20) < playfield_area.position.x):
			velocity.x = 0
		else:
			velocity.x -= 1

	velocity = velocity.normalized() * speed
					
	move_and_collide(velocity*delta)

