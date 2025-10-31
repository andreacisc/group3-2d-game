extends Node2D

@onready var sfx_mineral_pickup: AudioStreamPlayer = $"../astronaunt_player/sfx_mineral_pickup"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body):
	if body is Astronaunt:
		self.queue_free()
		sfx_mineral_pickup.play()
