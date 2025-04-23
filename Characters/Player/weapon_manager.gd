extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapons = $Weapons.get_children()

var weapons_unlocked = []
var cur_slot := 0
var cur_weapon = null
var reload := false

@onready var nearby_enemies_alert_area_small: Area3D = $NearbyEnemiesAlertAreaSmall
@onready var nearby_enemies_alert_area_large: Area3D = $NearbyEnemiesAlertAreaLarge
@onready var los_ray_cast: RayCast3D = $LOSRayCast
@onready var reload_timer: Timer = $ReloadTimer


func _ready():
	for weapon in weapons:
		if !weapon.silent_weapon:
			weapon.fired.connect(alert_enemies_on_fired)
		if weapon.has_method("set_bodies_to_exclude"):
			weapon.set_bodies_to_exclude([get_parent().get_parent()])
	disable_all_weapons()
	for _i in range(weapons.size()):
		#weapons_unlocked.append(false)
		weapons_unlocked.append(true)
	switch_to_weapon_slot(0)


func _process(delta: float) -> void:
	if reload:
		var reload_percent = (reload_timer.wait_time - reload_timer.time_left)/cur_weapon.reload_time
		get_tree().call_group("HUD", "update_reload_bar", reload_percent)


func attack(input_just_pressed: bool, input_held: bool):
	if reload:
		return
	if cur_weapon is Weapon:
		cur_weapon.attack(input_just_pressed, input_held)


func disable_all_weapons():
	for weapon in weapons:
		if weapon.has_method("set_active"):
			weapon.set_active(false)
		else:
			weapon.hide()


func switch_to_previous_weapon():
	for i in range(weapons.size()):
		var wrapped_ind = wrapi(cur_slot -1 -i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_ind):
			break


func switch_to_next_weapon():
	for i in range(weapons.size()):
		var wrapped_ind = wrapi(cur_slot +1 +i, 0, weapons.size())
		if switch_to_weapon_slot(wrapped_ind):
			break


func switch_to_weapon_slot(slot_ind: int) -> bool:
	if slot_ind >= weapons.size() or slot_ind < 0:
		return false
	if weapons_unlocked.size() == 0 or !weapons_unlocked[slot_ind]:
		return false
	disable_all_weapons()
	cur_slot = slot_ind
	cur_weapon = weapons[cur_slot]
	if cur_weapon.has_method("set_active"):
		cur_weapon.set_active(true)
	else:
		cur_weapon.show()
	return true


func update_animation(velocity: Vector3, grounded: bool):
	if cur_weapon is Weapon and !cur_weapon.is_idle():
		animation_player.play("RESET")
	elif !grounded or velocity.length() < 5.0:
		animation_player.play("RESET", .3)
	else:
		animation_player.play("moving", .3)


func alert_enemies_on_fired():
	for enemy in nearby_enemies_alert_area_small.get_overlapping_bodies():
		if enemy is Enemy:
			enemy.alert()
	
	for enemy in nearby_enemies_alert_area_large.get_overlapping_bodies():
		if enemy is Enemy:
			los_ray_cast.enabled = true
			los_ray_cast.target_position = los_ray_cast.to_local(enemy.vision_manager.global_position)
			los_ray_cast.force_raycast_update()
			if !los_ray_cast.is_colliding():
				enemy.alert()
			los_ray_cast.enabled = false


func reload_weapon():
	if reload:
		return
	if cur_weapon.ammo < 0:
		return
	cur_weapon.play_reload_weapon_effect()
	reload = true
	reload_timer.start(cur_weapon.reload_time)
	get_tree().call_group("HUD", "reload_container_visible", true)


func _on_reload_timer_timeout() -> void:
	if cur_weapon is Weapon:
		cur_weapon.ammo = cur_weapon.max_ammo
	reload = false
	get_tree().call_group("HUD", "update_ammo_display", cur_weapon.ammo)
	get_tree().call_group("HUD", "reload_container_visible", false)
