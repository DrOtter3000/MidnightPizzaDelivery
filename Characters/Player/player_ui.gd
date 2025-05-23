extends CanvasLayer


@onready var health_bar: ProgressBar = %HealthBar
@onready var ammo_label: Label = %AmmoLabel
@onready var health_manager: Node3D = $"../HealthManager"
@onready var weapon_manager: Node3D = $"../Camera3D/WeaponManager"
@onready var reload_container: MarginContainer = $CenterContainer/ReloadContainer
@onready var reload_bar: ProgressBar = $CenterContainer/ReloadContainer/ReloadBar


func _ready() -> void:
	health_manager.health_changed.connect(update_health_display)
	for weapon in weapon_manager.weapons:
		weapon.ammo_updated.connect(update_ammo_display)
	update_health_display(health_manager.cur_health, health_manager.max_health)
	update_ammo_display(weapon_manager.cur_weapon.ammo)


func update_health_display(cur_health: int, max_health: int):
	health_bar.max_value = max_health
	health_bar.value = cur_health


func update_ammo_display(ammo_amnt: int):
	if ammo_amnt < 0:
		ammo_label.text = " "
	else:
		ammo_label.text = "Ammo: %s" % ammo_amnt


func update_reload_bar(percent: float):
	reload_bar.value = percent


func reload_container_visible(value: bool):
	reload_container.visible = value
