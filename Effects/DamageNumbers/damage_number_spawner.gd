extends Node3D


@export var active := true
@export var damage_number_scene: PackedScene


func spawn_number(amount: float, hurt: bool):
	if !active:
		return
	
	var damage_number = damage_number_scene.instantiate()
	add_child(damage_number)
	damage_number.update_text(amount, hurt)
