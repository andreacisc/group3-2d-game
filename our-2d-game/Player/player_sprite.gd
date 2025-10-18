extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = -400.0
@export var gravity: float = 900.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0  # reset vertical velocity when grounded

	# Horizontal input
	var input_dir = Input.get_axis("ui_left", "ui_right")
	velocity.x = input_dir * move_speed

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		$AnimatedSprite2D.play("Jump")

	# Animation logic
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump")
	elif input_dir != 0:
		$AnimatedSprite2D.play("Left")   # always play "Left"
		$AnimatedSprite2D.flip_h = input_dir > 0  # flip for right
	else:
		$AnimatedSprite2D.play("Idle")

	# Move the character
	move_and_slide()
