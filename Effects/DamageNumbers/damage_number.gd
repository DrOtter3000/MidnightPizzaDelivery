extends Node3D


@onready var label_3d: Label3D = %Label3D
var speed: float
var min_speed := 1.5
var max_speed := 2.5

func _ready() -> void:
	position.x = randf_range(-.3, .3)
	speed = randf_range(min_speed, max_speed)


func _process(delta: float) -> void:
	position.y += speed * delta


func update_text(amount: int, hurt: bool):
	print(position)
	label_3d.text = str(amount)
	if hurt:
		label_3d.modulate = Color.WHITE
	else:
		label_3d.modulate = Color.WEB_GREEN
