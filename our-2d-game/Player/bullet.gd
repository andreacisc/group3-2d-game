extends Area2D

@export var speed: float = 900.0
@export var damage: int = 1
var direction: Vector2 = Vector2.RIGHT
var shooter: Node = null

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_Bullet_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):   # make sure your alien is in "enemy" group
		body.take_damage(damage)    # call the enemy’s damage function
		queue_free()
	elif not body.is_in_group("player"):
		queue_free()  # bullet disappears on hitting walls/other things
