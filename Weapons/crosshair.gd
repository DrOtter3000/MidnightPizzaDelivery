extends CenterContainer


@onready var crosshair_shape: Control = $CrosshairShape


enum CROSSHAIRS {
	CIRCLE, CROSS_WITH_CIRCLE, CROSS, RECTANGLE
}

@export var crosshair_type: CROSSHAIRS


func _ready() -> void:
	crosshair_shape.draw_shape(crosshair_type)
