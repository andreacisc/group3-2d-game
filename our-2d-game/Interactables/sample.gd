extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if has_meta("rarity"):
			var rarity = get_meta("rarity")
			if Global.SAMPLE_VALUES.has(rarity):
				Global.sample_score += Global.SAMPLE_VALUES[rarity]
				Global.sample_count += 1
				Global.sample_rarity_count[rarity] += 1
		else:
			Global.samples += 1
		body.update_UI()
		queue_free()  
