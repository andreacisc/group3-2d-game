extends Area2D

@export var speed: float = 900.0
@export var damage: int = 1
var direction: Vector2 = Vector2.RIGHT
var shooter: Node = null

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	print("Bullet hit:", body.name, " Groups:", body.get_groups())
	if body.is_in_group("enemy"):
		if body.has_method("take_damage"):
			body.take_damage(damage, shooter)
		queue_free()
	elif not body.is_in_group("player"):
		queue_free()
