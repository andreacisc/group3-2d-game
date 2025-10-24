extends CharacterBody2D

@export var move_speed: float = 200.0
@export var jump_force: float = -250.0
@export var gravity: float = 900.0

var jump_count: int = 0
const MAX_JUMPS: int = 2


func _ready():
	update_UI()
	jump_count = 0


func update_UI():
	%Health.text = "HEALTH: " + str(Global.health) 
	%Samples.text = "SAMPLES: " + str(Global.samples)
	%Stims.text = "STIMS: " + str(Global.stims)


func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement (A/D or Arrow Keys)
	var input_dir := 0.0
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("ui_left"):
		input_dir -= 1.0
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("ui_right"):
		input_dir += 1.0
	velocity.x = input_dir * move_speed

	# Jump (W, Space, or Enter)
	if (Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_accept")) and jump_count < MAX_JUMPS:
		if jump_count == 0:
			# First jump: full force
			velocity.y = jump_force
		else:
			# Second jump: only add 5% of the normal jump force
			velocity.y += jump_force * 2.0
		jump_count += 1
		$Player_Sprite.play("Jump")

	# Animation logic
	if not is_on_floor():
		$Player_Sprite.play("Jump")
	elif input_dir != 0:
		$Player_Sprite.play("Left")  # Use "Left" for both directions
		$Player_Sprite.flip_h = input_dir > 0  # Flip when moving right
	else:
		$Player_Sprite.play("Idle")

	# Move the character
	move_and_slide()
	if is_on_floor():
		jump_count = 0


#Handle collisions with pickups
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("stim"):
		Global.stims += 1
		update_UI()
		body.queue_free()
	elif body.is_in_group("sample"):
		if body.has_meta("rarity"):
			var rarity = body.get_meta("rarity")
			if Global.SAMPLE_VALUES.has(rarity):
				Global.sample_score += Global.SAMPLE_VALUES[rarity]
				Global.sample_count += 1
				Global.sample_rarity_count[rarity] += 1
		update_UI()
		body.queue_free()
