extends CharacterBody3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var character_mover: Node3D = $CharacterMover

@export var mouse_sensetivity := .15


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards")
	var move_dir = (transform.basis * Vector3(input_dir.x , 0, input_dir.y)).normalized()
	
	character_mover.set_move_dir(move_dir)
	if Input.is_action_just_pressed("jump"):
		character_mover.jump()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensetivity
		camera_3d.rotation_degrees.x -= event.relative.y * mouse_sensetivity
		camera_3d.rotation_degrees.x = clamp(camera_3d.rotation_degrees.x, -90, 90)
