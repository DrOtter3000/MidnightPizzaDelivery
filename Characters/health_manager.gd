extends Node3D

# TODO: add "instanced" to restart params

const BLOOD_HIT_EFFECT = preload("res://Effects/Blood_Effects/blood_hit_effect.tscn")
const BLOOD_DECAL = preload("res://Effects/Blood_Effects/blood_decal.tscn")
const GIB = preload("res://Effects/Gib/gib.tscn")

@onready var blood_raycast: RayCast3D = $BloodRaycast
@onready var damage_number_spawner: Node3D = $"../DamageNumberSpawner"

@export var max_health := 10
@export var cur_health := max_health
@export var gib_when_damage_taken := 20
@export var gib_spawn_amount := 5
var has_gibbed := false

@export var blood_splatter_count := 3
@export var blood_splatter_range := 2.0
@export var blood_splatter_size_variance := .5

@export var verbose := false

signal died
signal healed
signal damaged
signal gibbed
signal health_changed(cur_health, max_health)


func _ready() -> void:
	cur_health = max_health
	health_changed.emit(cur_health, max_health)
	if verbose:
		print("starting health: %s/%s" % [cur_health, max_health])


var damage_taken_this_frame := 0.0
var last_frame_damaged := -1
func hurt(damage_data: DamageData):
	spawn_bolld_effects(damage_data)
	
	var cur_frame = Engine.get_process_frames()
	if last_frame_damaged != cur_frame:
		damage_taken_this_frame = 0
	last_frame_damaged = cur_frame
	damage_taken_this_frame += damage_data.amount
	
	var dead = cur_health <= 0
	if dead and damage_taken_this_frame >= gib_when_damage_taken:
		gib()
	
	if dead:
		return
	
	damage_number_spawner.spawn_number(damage_data.amount, true)
	
	cur_health -= damage_data.amount
	dead = cur_health <= 0
	
	if dead:
		if verbose:
			print(str(get_parent().name) + " died")
		died.emit()
		$DieSound.play_sound()
		if dead and damage_taken_this_frame >= gib_when_damage_taken:
			gib()
	else:
		damaged.emit()
		$HurtSound.play_sound()
	health_changed.emit(cur_health, max_health)
	if verbose:
		print("damaged for %s, health: %s/%s" % [damage_data.amount, cur_health, max_health])


func gib():
	if has_gibbed:
		return
	has_gibbed = true
	gibbed.emit()
	
	for _i in gib_spawn_amount:
		var gib_inst = GIB.instantiate()
		get_tree().get_root().add_child(gib_inst)
		gib_inst.global_position = global_position
		gib_inst.add_to_group("instanced")
	
	if verbose:
		print(str(get_parent().name) + " gibbed")


func heal(amount: int):
	if cur_health <= 0:
		return
	cur_health = clamp(cur_health + amount, 0, max_health)
	healed.emit()
	health_changed.emit(cur_health, max_health)
	if verbose:
		print("healed for %s, health: %s/%s" % [amount, cur_health, max_health])


func spawn_bolld_effects(damage_data: DamageData):
	var blood_hit_effect = BLOOD_HIT_EFFECT.instantiate()
	get_tree().get_root().add_child(blood_hit_effect)
	blood_hit_effect.global_position = damage_data.hit_pos
	
	blood_raycast.enabled = true
	for _i in blood_splatter_count:
		var h_angle = randf_range(0.0, PI / 2.0)
		var v_angle = randf_range(0.0, TAU)
		var dir = Vector3.DOWN.rotated(Vector3.RIGHT, h_angle)
		dir = dir.rotated(Vector3.UP, v_angle)
		var raycast_to = global_position + dir * blood_splatter_range
		blood_raycast.target_position = blood_raycast.to_local(raycast_to)
		blood_raycast.force_raycast_update()
		if !blood_raycast.is_colliding():
			continue
		
		var hit_pos = blood_raycast.get_collision_point()
		var hit_normal = blood_raycast.get_collision_normal()
		var blood_decal = BLOOD_DECAL.instantiate()
		get_tree().get_root().add_child(blood_decal)
		blood_decal.global_position = hit_pos
		blood_decal.add_to_group("instanced")
		var look_at_pos = hit_pos + hit_normal
		if hit_normal.is_equal_approx(Vector3.UP) or hit_normal.is_equal_approx(Vector3.DOWN):
			blood_decal.look_at(look_at_pos, Vector3.RIGHT)
		else:
			blood_decal.look_at(look_at_pos)
		
		blood_decal.rotate_object_local(Vector3.FORWARD, randf_range(0.0, TAU))
		blood_decal.scale *= 1.0 + randf_range(-blood_splatter_size_variance, blood_splatter_size_variance)
	
	blood_raycast.enabled = false
