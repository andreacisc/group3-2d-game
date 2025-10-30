extends CharacterBody2D


@export var move_speed: float = 100.0




func _process(delta: float) -> void:
	
	var direction : Vector2 = Vector2.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if direction.y == 0 and direction.x == 0:
		$AnimatedSprite2D.play("idle")
	
	if Input.is_action_pressed("move_left"):
		$AnimatedSprite2D.play("left_right")
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("move_right"):
		$AnimatedSprite2D.play("left_right")
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("move_up"):
		$AnimatedSprite2D.play("up")


	velocity = direction * move_speed



func _physics_process(delta: float) -> void:
	
	move_and_slide()



func _on_area_2d_body_entered(body) -> void:
	$"../type1_sample".queue_free()
