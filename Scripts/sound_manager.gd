extends AudioStreamPlayer


@export var available_sounds: Array
@export var pitch_rate_min := 1.0
@export var pitch_rate_max := 1.0
@export var volume_max := 1.0
@export var volume_min := 1.0


func play_sound():
	volume_db = randf_range(volume_min, volume_max)
	stream = load(available_sounds.pick_random())
	pitch_scale = randf_range(pitch_rate_min, pitch_rate_max)
	play()
