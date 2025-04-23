extends Node

@onready var test_sound_player: AudioStreamPlayer = $TestSoundPlayer


func update_audio_bus(new_value: float, bus: String):
	var new_db_value: float = linear_to_db(new_value)
	var bus_id = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_id, new_db_value)


func play_test_sound(value):
	if test_sound_player.bus == "Music":
		return
	test_sound_player.play()
