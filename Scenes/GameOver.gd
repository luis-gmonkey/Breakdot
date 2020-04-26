extends Node2D


func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
