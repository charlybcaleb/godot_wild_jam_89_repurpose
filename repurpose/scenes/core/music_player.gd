extends AudioStreamPlayer

@export var track_2: AudioStream

func _ready():
	connect("finished", Callable(self, "_on_audio_finished"))
	play_track_2()

func play_track_2():
	stream = track_2
	play()

func _on_audio_finished():
	play_track_2()
