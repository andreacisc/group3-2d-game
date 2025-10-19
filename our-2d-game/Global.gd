extends Node2D

@export var move_speed: float = 100.0
@export var jump_force: float = -150.0
@export var gravity: float = 900.0

var health: int = 100
var max_health: int = 100
var samples: int = 0
var stims: int = 0   

const SAMPLE_VALUES = {
	"common": 10,
	"rare": 25,
	"super_rare": 50
}

func heal(amount: int) -> void:
	health += amount
	if health > max_health:
		health = max_health

# NEW: use a stim to heal up to max health
func use_stim() -> void:
	if stims > 0 and health < max_health:
		stims -= 1
		heal(max_health)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("stim"):
		stims += 1   # NEW: collect stim instead of instant heal
		body.queue_free()
	elif body.is_in_group("sample"):
		if body.has_meta("rarity"):
			var rarity = body.get_meta("rarity")
			if SAMPLE_VALUES.has(rarity):
				Global.sample_score += SAMPLE_VALUES[rarity]
				Global.sample_count += 1
				Global.sample_rarity_count[rarity] += 1
		body.queue_free()
