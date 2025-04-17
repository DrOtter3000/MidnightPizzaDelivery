extends AudioStreamPlayer3D


@export var available_sounds: Array
@export var pitch_rate_min := 1.0
@export var pitch_rate_max := 1.0
@export var volume_max := 1.0
@export var volume_min := 1.0
# percentage of probability to play sound
@export var play_random := 0.0


func play_sound():
	if available_sounds.size() == 0:
		pass
	
	else:
		volume_db = randf_range(volume_min, volume_max)
		stream = load(available_sounds.pick_random())
		pitch_scale = randf_range(pitch_rate_min, pitch_rate_max)
		play()


func play_idle_sound():
	if play_random > 0:
		var sound_play_probability = randf_range(0, 1)
		if sound_play_probability < play_random:
			play_sound()
	else:
		play_sound()
