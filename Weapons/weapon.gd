extends Node3D
class_name Weapon

@onready var animation_player: AnimationPlayer = $Graphics/AnimationPlayer
@onready var bullet_emitter: BulletEmitter = $BulletEmitter
@onready var fire_point: Node3D = %FirePoint

@onready var equip_sound: AudioStreamPlayer = $EquipSound
@onready var out_of_ammo_sound: AudioStreamPlayer = $OutOfAmmoSound
@onready var attack_sound: AudioStreamPlayer = $AttackSound


@export var automatic := false

@export var damage := 5
@export var ammo := 30
@export var attack_rate := .2
@export var animation_controlled_attack := false
@export var silent_weapon := false

var last_attack_time := -9999.9

signal fired
signal out_of_ammo
signal ammo_updated(ammo_amt: int)


func _ready() -> void:
	bullet_emitter.set_damage(damage)


func set_bodies_to_exclude(bodies: Array):
	bullet_emitter.set_bodies_to_exclude(bodies)


func attack(input_just_pressed: bool, input_held: bool):
	if !automatic and !input_just_pressed:
		return
	if automatic and !input_held:
		return
	if ammo == 0:
		if input_just_pressed:
			out_of_ammo.emit()
			out_of_ammo_sound.play_sound()
		return
	
	var cur_time = Time.get_ticks_msec() / 1000.0
	if cur_time - last_attack_time < attack_rate:
		return
	
	if ammo > 0:
		ammo -= 1
	
	if !animation_controlled_attack:
		actually_attack()
	
	last_attack_time = cur_time
	animation_player.stop()
	animation_player.play("attack")
	fired.emit()
	attack_sound.play_sound()
	ammo_updated.emit(ammo)
	if has_node("Graphics/MuzzleFlash"):
		$Graphics/MuzzleFlash.flash()


func set_active(a: bool):
	$Crosshair.visible = a
	visible = a
	if !a:
		animation_player.play("RESET")
	else:
		equip_sound.play_sound()
		ammo_updated.emit(ammo)


func actually_attack():
	bullet_emitter.global_transform = fire_point.global_transform
	bullet_emitter.fire()


func is_idle() -> bool:
	return !animation_player.is_playing()


func add_ammo(amnt: int):
	ammo += amnt
	ammo_updated.emit(ammo)
