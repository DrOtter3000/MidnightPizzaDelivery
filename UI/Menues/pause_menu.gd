extends CanvasLayer


@onready var pause_menu: VBoxContainer = $PauseMenu
@onready var options_menu: VBoxContainer = $OptionsMenu
@onready var fullscreen_button: Button = $OptionsMenu/FullscreenButton


func _ready() -> void:
	change_fullscreen_text()
	visible = false
	pause_menu.visible = true
	options_menu.visible = false


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
