extends Node2D

@export var AlienScene: PackedScene
@export var spawn_interval: float = 15.0

var can_spawn := true

func _ready():
	$SpawnTimer.wait_time = spawn_interval
	$SpawnTimer.start()
	$StopZone.body_entered.connect(_on_StopZone_body_entered)

func _on_SpawnTimer_timeout():
	if can_spawn and AlienScene:
		var alien = AlienScene.instantiate()
		alien.global_position = $SpawnPoint.global_position
		get_parent().add_child(alien)

func _on_StopZone_body_entered(body: Node) -> void:
	if body.name == "Player":
		can_spawn = false
		$SpawnTimer.stop()
