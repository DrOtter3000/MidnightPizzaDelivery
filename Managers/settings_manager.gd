extends Node


var fullscreen := true


func _ready() -> void:
	update_fullscreen(fullscreen)


func update_fullscreen(value: bool):
	fullscreen = value
	if value == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
