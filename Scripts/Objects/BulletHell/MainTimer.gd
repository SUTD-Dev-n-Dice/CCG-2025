extends Label

var timer

@export var totalTime: int = 180
var currentTime: int

@onready var game_manager = get_node("/root/BulletHell")

func _ready():
	currentTime = totalTime
	timer = Timer.new()
	timer.timeout.connect(_on_timer_timeout)
	timer.set_wait_time(1) #value is in seconds
	timer.set_one_shot(false)
	add_child(timer) 
	timer.start() 

func _on_timer_timeout():
	if game_manager.getState():
		return
	
	currentTime -= 1
	
	var minutes = int(currentTime / 60)
	var seconds = int(currentTime % 60)
	
	print(minutes, " : ", str(seconds).pad_zeros(2) )
	set_text(str(str(minutes).pad_zeros(2), " : ", str(seconds).pad_zeros(2)))
	
	if currentTime <= 0:
		game_manager.game_win()
