extends CharacterBody2D

enum State { IDLE, CHASING, ATTACKING, DAMAGED, DEFEATED }
var state: State = State.IDLE

@export var move_speed: float = 80.0
@export var detection_radius: float = 150.0
@export var attack_range: float = 40.0
@export var damage: int = 2
@export var max_health: int = 5
@export var gravity: float = 900.0

var current_health: int
var player: Node = null
var anim: AnimatedSprite2D
var player_in_range: Node = null  

func _ready():
	anim = $AnimatedSprite2D
	player = get_tree().get_first_node_in_group("player")
	current_health = max_health
	change_state(State.IDLE)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	match state:
		State.IDLE:
			velocity.x = 0
			if player and global_position.distance_to(player.global_position) <= detection_radius:
				change_state(State.CHASING)

		State.CHASING:
			if not player: return
			var distance = global_position.distance_to(player.global_position)
			if distance <= attack_range:
				change_state(State.ATTACKING)
			elif distance > detection_radius:
				change_state(State.IDLE)
			else:
				var direction = (player.global_position - global_position).normalized()
				velocity.x = direction.x * move_speed
				if direction.x != 0:
					anim.flip_h = direction.x < 0

		State.ATTACKING:
			velocity.x = 0
			if player:
				var dir_x = player.global_position.x - global_position.x
				if dir_x != 0:
					anim.flip_h = dir_x < 0
			if player and global_position.distance_to(player.global_position) > attack_range:
				change_state(State.CHASING)

		State.DAMAGED:
			velocity.x = 0

		State.DEFEATED:
			velocity = Vector2.ZERO

	move_and_slide()

func change_state(new_state: State) -> void:
	state = new_state
	match state:
		State.IDLE: anim.play("idle")
		State.CHASING: anim.play("running")
		State.ATTACKING: anim.play("attack")
		State.DAMAGED: anim.play("damaged")
		State.DEFEATED: anim.play("defeated")

func take_damage(amount: int, shooter: Node = null) -> void:
	if state == State.DEFEATED:
		return

	current_health -= amount
	if shooter:
		player = shooter

	if current_health > 0:
		change_state(State.DAMAGED)
		await get_tree().create_timer(0.5).timeout
		if state != State.DEFEATED:
			change_state(State.CHASING)
	else:
		change_state(State.DEFEATED)
		await anim.animation_finished
		queue_free()

		if shooter and shooter.is_in_group("player"):
			shooter.kills += 1
			shooter.update_UI()

func _on_area_2d__hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and state != State.DEFEATED:
		body.health -= damage
		body.update_UI()
		player_in_range = body
		start_attack_cycle()

func _on_area_2d__hitbox_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null

func start_attack_cycle() -> void:
	while player_in_range and state != State.DEFEATED:
		if player_in_range.health <= 0:
			player_in_range = null
			break
		player_in_range.health -= damage
		player_in_range.update_UI()
		await get_tree().create_timer(1.0).timeout
