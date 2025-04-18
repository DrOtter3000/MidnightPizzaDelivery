extends Node3D


@onready var character_mover: CharacterMover = get_parent()
@onready var last_pos = global_position

@onready var step_player: AudioStreamPlayer = $StepPlayer

@export var step_after_distance := 3.0

var dist_travelled_since_last_step := 0.0


func _physics_process(delta: float) -> void:
	if !character_mover.character_body.is_on_floor():
		dist_travelled_since_last_step = 0.0
	
	dist_travelled_since_last_step += global_position.distance_to(last_pos)
	if dist_travelled_since_last_step >= step_after_distance:
		dist_travelled_since_last_step = 0.0
		step_player.play_sound()
	
	last_pos = global_position
