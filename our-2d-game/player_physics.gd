extends CharacterBody2D

@export var move_speed: float = 100.0
@export var jump_force: float = -150.0
@export var gravity: float = 900.0

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	# Horizontal movement (A/D or Arrow Keys)
	var input_dir := 0.0
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		input_dir -= 1.0
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		input_dir += 1.0
	velocity.x = input_dir * move_speed

	# Jump (W, Space, or Enter)
	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")) and is_on_floor():
		velocity.y = jump_force
		$Player_Sprite.play("Jump")

	# Animation logic
	if not is_on_floor():
		$Player_Sprite.play("Jump")
	elif input_dir != 0:
		$Player_Sprite.play("Left")
		$Player_Sprite.flip_h = input_dir > 0
	else:
		$Player_Sprite.play("Idle")

	# Move the character
	move_and_slide()
