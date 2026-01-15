extends AudioStreamPlayer2D

var audio_player_scene = preload("res://scenes/core/audio_stream_player_2d.tscn")
var hit_sound_player: AudioStreamPlayer2D
var hit_sounds: Array[AudioStream]
var hit_sound_0 = preload("res://assets/sounds/hit_sound_0.wav")
var hit_sound_1 = preload("res://assets/sounds/hit_sound_1.wav")
var hit_sound_2 = preload("res://assets/sounds/hit_sound_2.wav")

func _ready() -> void:
	#hit_sound_0 = load("res://assets/sounds/hit_sound_0.wav")
	#hit_sound_1 = load("res://assets/sounds/hit_sound_1.wav")
	#hit_sound_2 = load("res://assets/sounds/hit_sound_2.wav")
	hit_sounds.append(hit_sound_0)
	hit_sounds.append(hit_sound_1)
	hit_sounds.append(hit_sound_2)
	hit_sound_player = audio_player_scene.instantiate()
	get_tree().current_scene.add_child(hit_sound_player)

func play_hit():
	hit_sound_player.stream = hit_sounds[randi_range(0,2)]
	hit_sound_player.play()
	
