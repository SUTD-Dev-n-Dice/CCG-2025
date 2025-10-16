extends Control

@onready var progress_bar: TextureProgressBar = $TextureProgressBar

@export var label: String = "Skill":
	set(value):
		label = value
		$Label.text = label
@export var color: Color = Color.WHITE:
	set(value):
		color = value
		var tx: GradientTexture2D = $TextureProgressBar.texture_progress
		tx.gradient.colors = PackedColorArray([Color(color, 225.0 / 255.0)])
@export var cooldown: float = 1.0

var time: float = -1:
	set(value):
		time = value
		if time == -1:
			progress_bar.value = progress_bar.max_value
		else:
			progress_bar.value = progress_bar.min_value + \
				((time / cooldown) * (progress_bar.max_value - progress_bar.min_value))
		if time >= cooldown:
			time = -1;

func _process(delta: float) -> void:
	if time != -1:
		time += delta
