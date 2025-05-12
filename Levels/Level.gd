extends Node3D


@export var waves := 1

@export var melee: PackedScene
@export var range: PackedScene

@export var enemy_types = {
	"melee": 30,
	"range": 5,
}

@onready var spawn_positions: Array = $SpawnPositions.get_children()


func _ready() -> void:
	spawn_enemies()


func spawn_enemies():
	var possible_position = spawn_positions.duplicate()
	for type in enemy_types:
		if enemy_types[type] <= 0:
			continue
		var type_to_spawn
		
		match type:
			"melee":
				type_to_spawn = melee
			"range":
				type_to_spawn = range
		
		for _i in enemy_types[type]:
			var spawn_location = possible_position.pick_random()
			possible_position.erase(spawn_location)
			var new_enemy = type_to_spawn.instantiate()
			add_child(new_enemy)
			new_enemy.position = spawn_location.position
			
