extends Node3D


@onready var chair: Node3D = $SM_Prop_Chair_07


func _ready() -> void:
	chair.rotation.y += deg_to_rad(randf_range(-25, 25))
	chair.position.z = randf_range(.6, .8)
