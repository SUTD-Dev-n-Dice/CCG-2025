extends HBoxContainer

@onready var heart_bars = [
	$heart1,
	$heart2,
	$heart3
]

func init_ui(max_health_quarters: int):
	for heart in heart_bars:
		heart.value = 4

func update_hearts(current_health: int):
	var quarters = current_health
	for i in range(heart_bars.size()):
		var heart_min = i * 4 + 1
		var heart_max = (i + 1) * 4
		
		if quarters >= heart_max:
			heart_bars[i].value = 4
		elif quarters < heart_min:
			heart_bars[i].value = 0
		else:
			var quarters_in_heart = quarters - (heart_min - 1)
			heart_bars[i].value = quarters_in_heart
