extends Node2D

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	$animated_planet.play()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Level 1/level_1.tscn")
	TransitionScreen.transition()


func _on_game_rules_button_pressed() -> void:
	get_tree().change_scene_to_file("res://start_menu/game_rules_scene.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
