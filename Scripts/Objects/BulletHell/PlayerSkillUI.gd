extends VBoxContainer

const Player = preload("res://Scripts/Objects/BulletHell/Player.gd")
const SkillControl = preload("res://Scripts/Objects/BulletHell/PlayerSkillControl.gd")

@onready var controls: Dictionary[Player.PlayerSkill, SkillControl] = {
	Player.PlayerSkill.JUMP: $Jump,
	Player.PlayerSkill.SPIKE: $Spike,
	Player.PlayerSkill.WAVE: $Wave,
	Player.PlayerSkill.TBC: $TBC,
}

@export var color: Color = Color.WHITE:
	set(value):
		color = value
		for skill in controls:
			controls[skill].color = color

func can_trigger(skill: Player.PlayerSkill) -> bool:
	return controls[skill].time == -1

func trigger(skill: Player.PlayerSkill) -> void:
	controls[skill].time = 0

func _ready():
	color = color
	for skill in Player.skill_cooldowns:
		controls[skill].cooldown = Player.skill_cooldowns[skill]
		controls[skill].time = -1
