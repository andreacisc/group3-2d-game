extends CharacterBody2D

# -------------------------
# Movement Variables
# -------------------------
@export var move_speed: float = 200.0
@export var jump_force: float = -250.0
@export var gravity: float = 900.0

var jump_count: int = 0
const MAX_JUMPS: int = 2

# -------------------------
# Shooting / Gun Variables
# -------------------------
@export var BulletScene: PackedScene
@export var fire_rate: float = 0.1      # seconds between shots (AK47 ~600 RPM)
@export var mag_size: int = 30          # magazine size
@export var reload_time: float = 2.0    # reload duration (seconds)

var current_ammo: int
var can_shoot: bool = true
var reloading: bool = false

# -------------------------
# Stim Variables
# -------------------------
@export var stim_cooldown: float = 1.0   # seconds between stim uses
var can_use_stim: bool = true

# -------------------------
# Internal offsets
# -------------------------
var muzzle_base_pos: Vector2

# -------------------------
# Ready
# -------------------------
func _ready():
	update_UI()
	jump_count = 0
	current_ammo = mag_size
	muzzle_base_pos = $Gun/Marker2D.position

# -------------------------
# UI Updates
# -------------------------
func update_UI():
	%Health.text = "HEALTH: " + str(Global.health) 
	%Samples.text = "SAMPLES: " + str(Global.samples)
	%Stims.text = "STIMS: " + str(Global.stims)
	# Optional ammo display if you add a Label named "Ammo"
	if has_node("%Ammo"):
		%Ammo.text = "AMMO: " + str(current_ammo) + "/" + str(mag_size)

# -------------------------
# Physics Process (Movement + Shooting)
# -------------------------
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
			velocity.y = jump_force
		else:
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

	# -------------------------
	# Shooting Input
	# -------------------------
	if Input.is_action_pressed("shoot") and can_shoot and not reloading:
		shoot()

	# Manual reload
	if Input.is_action_just_pressed("reload") and not reloading:
		start_reload()

	# -------------------------
	# Stim Usage Input
	# -------------------------
	if Input.is_action_just_pressed("use_stim") and can_use_stim:
		use_stim()

# -------------------------
# Gun Aiming (Cursor Follow)
# -------------------------
func _process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - $Gun.global_position).normalized()
	$Gun.rotation = dir.angle()

	# Flip the gun sprite vertically when aiming left
	$Gun/Gun_image.flip_v = dir.x < 0

	# Mirror the muzzle marker vertically when the sprite is flipped
	if $Gun/Gun_image.flip_v:
		$Gun/Marker2D.position = Vector2(muzzle_base_pos.x, -muzzle_base_pos.y)
	else:
		$Gun/Marker2D.position = muzzle_base_pos

# -------------------------
# Shooting Functions
# -------------------------
func shoot():
	if current_ammo <= 0:
		start_reload()
		return

	var bullet = BulletScene.instantiate()
	bullet.global_position = $Gun/Marker2D.global_position  # Marker2D at gun muzzle
	var dir = (get_global_mouse_position() - bullet.global_position).normalized()
	bullet.direction = dir
	bullet.shooter = self   # set shooter reference
	get_parent().add_child(bullet)

	current_ammo -= 1
	update_UI()

	can_shoot = false
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func start_reload():
	if current_ammo == mag_size:
		return # already full
	reloading = true
	can_shoot = false
	# Play reload animation/sound here if you have one
	await get_tree().create_timer(reload_time).timeout
	current_ammo = mag_size
	reloading = false
	can_shoot = true
	update_UI()

# -------------------------
# Stim Usage Function
# -------------------------
func use_stim():
	if Global.stims > 0 and Global.health < 100:
		Global.stims -= 1
		Global.health = 100   # fully heal
		update_UI()
		can_use_stim = false
		# Optional: play stim use animation or sound here
		await get_tree().create_timer(stim_cooldown).timeout
		can_use_stim = true

# -------------------------
# Handle collisions with pickups
# -------------------------
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
