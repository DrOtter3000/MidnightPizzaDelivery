extends Control

@onready var center_container: CenterContainer = $CenterContainer
@onready var main_container: VBoxContainer = $CenterContainer/MainContainer
@onready var options_container: VBoxContainer = $CenterContainer/OptionsContainer

@export var fullscreen := false


func _ready() -> void:
	main_container.show()
	options_container.hide()
	update_screen()


func update_screen():
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED) 


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_template.tscn")


func _on_options_button_pressed() -> void:
	main_container.hide()
	options_container.show()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	for window in center_container.get_children():
		window.hide()
	main_container.show()


func _on_fullscreen_button_pressed() -> void:
	fullscreen = !fullscreen
	update_screen()
