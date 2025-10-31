extends Node2D

@onready var sfx_plant_pickup: AudioStreamPlayer = $"../astronaunt_player/sfx_plant_pickup"

@export var value: int = 1



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$AnimatedSprite2D.play()


func _on_area_2d_body_entered(body):
	if body is Astronaunt:
		GameController.plant_collected(value)
		self.queue_free()
		sfx_plant_pickup.play()
