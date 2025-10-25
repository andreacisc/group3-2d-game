extends CharacterBody2D

enum State { IDLE, CHASING, ATTACKING, DAMAGED, DEFEATED }
var state: State = State.IDLE

@export var move_speed: float = 80.0
@export var detection_radius: float = 150.0
@export var attack_range: float = 40.0
@export var damage: int = 2
@export var max_health: int = 5

var current_health: int
var player: Node = null
var anim: AnimatedSprite2D

func _ready():
	anim = $AnimatedSprite2D
	player = get_tree().get_first_node_in_group("player")
	current_health = max_health
	change_state(State.IDLE)

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE:
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
				velocity = direction * move_speed
				move_and_slide()

		State.ATTACKING:
			velocity = Vector2.ZERO
			# Attack animation plays; damage is handled by hitbox
			if player and global_position.distance_to(player.global_position) > attack_range:
				change_state(State.CHASING)

		State.DAMAGED:
			velocity = Vector2.ZERO
			# Wait for animation to finish, then return to chase/idle
			pass

		State.DEFEATED:
			velocity = Vector2.ZERO
			# Enemy is dead, no further logic
			pass

func change_state(new_state: State) -> void:
	state = new_state
	match state:
		State.IDLE: anim.play("idle")
		State.CHASING: anim.play("running")
		State.ATTACKING: anim.play("attack")
		State.DAMAGED: anim.play("damaged")
		State.DEFEATED: anim.play("defeated")

# Called when Player enters enemy hitbox
func _on_Hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("player") and state != State.DEFEATED:
		Global.health -= damage
		body.update_UI()

# Called when the enemy takes damage (e.g. from bullet or player attack)
func take_damage(amount: int, shooter: Node = null) -> void:
	if state == State.DEFEATED: 
		return

	current_health -= amount

	# If a shooter was passed in (e.g. bullet), lock onto them
	if shooter:
		player = shooter

	if current_health > 0:
		change_state(State.DAMAGED)
		# After a short delay, return to chasing
		await get_tree().create_timer(0.5).timeout
		if state != State.DEFEATED:
			change_state(State.CHASING)
	else:
		change_state(State.DEFEATED)
		# Optionally remove enemy after animation
		await anim.animation_finished
		queue_free()
