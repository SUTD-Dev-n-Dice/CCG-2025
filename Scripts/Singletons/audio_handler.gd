extends Node

var audio_node = preload("res://Scenes/Objects/AudioNodeObject.tscn")

func play_audio(audio, volume:=-10.0, pitch_vary:bool=false):
	var audio_instance = audio_node.instantiate()
	var audio_name = "res://Assets/Audio/" + audio + ".wav"
	audio_instance.stream = load(audio_name)
	audio_instance.volume_db = volume
	if pitch_vary:
		audio_instance.pitch_scale *= randf_range(0.9,1.1)
	add_child(audio_instance)
