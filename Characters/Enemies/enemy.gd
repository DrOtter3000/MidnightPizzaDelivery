extends CharacterBody3D
class_name Enemy

@onready var health_manager: Node3D = $HealthManager
@onready var vision_manager: VisionManager = $VisionManager
@onready var nearby_enemies_alert_area: Area3D = $NearbyEnemiesAlertArea
@onready var ai_character_mover: Node3D = $AICharacterMover
@export var animation_player: AnimationPlayer

enum STATES {IDLE, ATTACK, DEAD}
var cur_state = STATES.IDLE

@onready var player = get_tree().get_first_node_in_group("Player")


func _ready() -> void:
	var hitboxes = find_children("*", "HitBox")
	for hitbox in hitboxes:
		hitbox.on_hurt.connect(health_manager.hurt)
	health_manager.died.connect(set_state.bind(STATES.DEAD))
	
	set_state(STATES.IDLE)


func _process(delta: float) -> void:
	match cur_state:
		STATES.IDLE:
			process_idle_state(delta)
		STATES.ATTACK:
			process_attack_state(delta)


func process_idle_state(delta):
	if vision_manager.can_see_player():
		alert()


func process_attack_state(delta):
	ai_character_mover.set_facing_dir(player.global_position - global_position)
	ai_character_mover.move_to_point(player.global_position)
	animation_player.play("Root|Walk")


func hurt(damage_data: DamageData):
	health_manager.hurt(damage_data)


func alert():
	if cur_state == STATES.IDLE:
		set_state(STATES.ATTACK)
		alert_nearby_enemies()

func alert_nearby_enemies():
	for b in nearby_enemies_alert_area.get_overlapping_bodies():
		if b is Enemy:
			b.alert()


func set_state(state: STATES):
	if cur_state == STATES.DEAD:
		return
	cur_state = state
	match cur_state:
		STATES.ATTACK:
			pass
		STATES.IDLE:
			animation_player.play("Root|Idle")
		STATES.DEAD:
			animation_player.play("Root|Die")
			collision_layer = 0
			collision_mask = 1
			ai_character_mover.stop_moving()
