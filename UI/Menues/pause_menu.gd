extends CanvasLayer


@onready var pause_menu: VBoxContainer = $PauseMenu
@onready var options_menu: VBoxContainer = $OptionsMenu
@onready var fullscreen_button: Button = $OptionsMenu/FullscreenButton
@onready var master_slider: HSlider = $OptionsMenu/MasterSlider
@onready var sfx_slider: HSlider = $OptionsMenu/SFXSlider
@onready var music_slider: HSlider = $OptionsMenu/MusicSlider


func _ready() -> void:
	change_fullscreen_text()
	visible = false
	pause_menu.visible = true
	options_menu.visible = false
	update_volume_sliders()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if get_tree().paused:
			if pause_menu.visible:
				continue_game()
			else:
				pause_menu.visible = true
				options_menu.visible = false
		else:
			get_tree().paused = true
			visible = true
		
		setup_cursor()


func update_volume_sliders():
	master_slider.value = get_volume_percent("Master")
	sfx_slider.value = get_volume_percent("SFX")
	music_slider.value = get_volume_percent("Music")


func get_volume_percent(bus: String):
	var volume_in_percent: float = 100.0 + AudioServer.get_bus_volume_db(AudioServer.get_bus_index(bus))
	return volume_in_percent


func continue_game():
	visible = false
	get_tree().paused = false


func setup_cursor():
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_options_button_pressed() -> void:
	pause_menu.visible = false
	options_menu.visible = true


func _on_fullscreen_button_pressed() -> void:
	var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if fs:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func change_fullscreen_text():
	var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	if fs: 
		fullscreen_button.text = "Toggle to Window Mode"
	else:
		fullscreen_button.text = "Toggle to Fullscreen"


func _on_back_button_pressed() -> void:
	options_menu.visible = false
	pause_menu.visible = true


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/Menues/main_menu.tscn")


func _on_continue_button_pressed() -> void:
	continue_game()
	setup_cursor()


func _on_master_slider_value_changed(value: float) -> void:
	if get_tree().paused:
		AudioManager.update_audio_bus(value/100, "Master")
		AudioManager.test_sound_player.bus = "Master"


func _on_sfx_slider_value_changed(value: float) -> void:
	if get_tree().paused:
		AudioManager.update_audio_bus(value/100, "SFX")
		AudioManager.test_sound_player.bus = "SFX"


func _on_music_slider_value_changed(value: float) -> void:
	if get_tree().paused:
		AudioManager.update_audio_bus(value/100, "Music")
		AudioManager.test_sound_player.bus = "Music"


func play_test_sound(value):
	AudioManager.play_test_sound(value)
