extends StaticBody2D

@export var platform_nodes:Array[PackedScene] = []
@export var player:Node2D

func _ready() -> void:
	get_colli
	pass

func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	pass
	var x:float = Input.get_action_strength("right1")
	print(x*x)
