extends Node

@export var total_purple_minerals: int = 0
@export var total_brown_rocks: int = 0
@export var total_plants: int = 0

func purple_mineral_collected(value : int):
	total_purple_minerals += value
	PurpleMineralEventController.emit_signal("purple_mineral_collected", total_purple_minerals)


func brown_rock_collected(value : int):
	total_brown_rocks += value
	BrownRockEventController.emit_signal("brown_rock_collected", total_brown_rocks)


func plant_collected(value : int):
	total_plants += value
	PlantEventController.emit_signal("plant_collected", total_plants)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
