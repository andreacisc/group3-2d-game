extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $ColorRect/AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color_rect.visible = false

func transition():
	color_rect.visible = true
	animation_player.play("fade_to_black")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
