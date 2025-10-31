extends Control

@onready var score: Label = $TextureRect/score



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BrownRockEventController.connect("brown_rock_collected", on_event_brown_rock_collected)


func on_event_brown_rock_collected(value: int) -> void:
	score.text = str(value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
