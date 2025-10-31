extends Node2D

@export var AlienScene: PackedScene
@export var spawn_interval: float = 2.0

var can_spawn := true
var spawn_points := []

func _ready():
	spawn_points = [
		$SpawnPoint1,
		$SpawnPoint2,
		$SpawnPoint3
	]
	$SpawnTimer.wait_time = spawn_interval
	$SpawnTimer.start()
	$SpawnTimer.timeout.connect(_on_SpawnTimer_timeout)
	$StopZone.body_entered.connect(_on_StopZone_body_entered)

func _on_SpawnTimer_timeout():
	if can_spawn and AlienScene and spawn_points.size() > 0:
		var spawn_point = spawn_points.pick_random()
		var alien = AlienScene.instantiate()
		alien.global_position = spawn_point.global_position
		get_parent().add_child(alien)

func _on_StopZone_body_entered(body: Node) -> void:
	if body.name == "Player":
		can_spawn = false
		$SpawnTimer.stop()
