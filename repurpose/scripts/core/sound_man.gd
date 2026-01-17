extends AudioStreamPlayer2D

var audio_player_scene = preload("res://scenes/core/audio_stream_player_2d.tscn")
var hit_sound_player: AudioStreamPlayer2D
var hit_sounds: Array[AudioStream]
var hit_sound_0 = preload("res://assets/sounds/hit_sound_0.wav")
var hit_sound_1 = preload("res://assets/sounds/hit_sound_1.wav")
var hit_sound_2 = preload("res://assets/sounds/hit_sound_2.wav")
var death_sound_player: AudioStreamPlayer2D
var pelfen_death_sounds: Array[AudioStream]
var pelfen_death_sound_0 = preload("res://assets/sounds/pelfen_death_sound_0.wav")
var pelfen_death_sound_1 = preload("res://assets/sounds/pelfen_death_sound_1.wav")

func _ready() -> void:
	hit_sounds.append(hit_sound_0)
	hit_sounds.append(hit_sound_1)
	hit_sounds.append(hit_sound_2)
	hit_sound_player = audio_player_scene.instantiate()
	get_tree().current_scene.add_child(hit_sound_player)
	pelfen_death_sounds.append(pelfen_death_sound_0)
	pelfen_death_sounds.append(pelfen_death_sound_1)
	death_sound_player = audio_player_scene.instantiate()
	get_tree().current_scene.add_child(death_sound_player)

func play_hit(entity_type= GlobalConstants.EntityType.ENEMY):
	if entity_type != GlobalConstants.EntityType.WORKABLE:
		hit_sound_player.stream = hit_sounds[randi_range(0,2)]
		hit_sound_player.play()

func play_death(npc_name: String):
	if npc_name == "Pelfen":
		death_sound_player.stream = pelfen_death_sounds[randi_range(0,1)]
		death_sound_player.play()
	else:
		death_sound_player.stream = pelfen_death_sounds[randi_range(0,1)]
		death_sound_player.play()
