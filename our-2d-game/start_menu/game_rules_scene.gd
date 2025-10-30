extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"): # using "jump" b/c indicated by space
		get_tree().change_scene_to_file("res://start_menu/start_scene.tscn")
