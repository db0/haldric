extends Control

const AttackPlate = preload("res://source/interface/hud/components/AttackPlate.tscn")

onready var unit_name := $NinePatchRect/CenterContainer/VBoxContainer/Name as Label
onready var image := $NinePatchRect/CenterContainer/VBoxContainer/Image/Unit as TextureRect
onready var level := $NinePatchRect/CenterContainer/VBoxContainer/General/Level as Label
onready var type := $NinePatchRect/CenterContainer/VBoxContainer/General/Type as Label
onready var race := $NinePatchRect/CenterContainer/VBoxContainer/General/Race as Label
onready var hp := $NinePatchRect/CenterContainer/VBoxContainer/HP as VBoxContainer
onready var xp := $NinePatchRect/CenterContainer/VBoxContainer/XP as VBoxContainer
onready var mp := $NinePatchRect/CenterContainer/VBoxContainer/MP as VBoxContainer
onready var defense := $NinePatchRect/CenterContainer/VBoxContainer/Image/Defense
onready var alignment := $NinePatchRect/CenterContainer/VBoxContainer/Aligment

onready var attacks := $NinePatchRect/CenterContainer/VBoxContainer/Attacks as VBoxContainer

onready var tween := $Tween as Tween
var unit: Unit = null

func _ready() -> void:
	clear_unit()

# TODO: maybe find a better way to do this
func _process(delta: float) -> void:
	if unit:
		image.texture = unit.sprite.texture

func update_unit(target: Unit) -> void:
	_clear_attack_plates()
	_fade_in()

	unit = target

	unit_name.text = unit.name
	image.texture = unit.sprite.texture
	image.set_material(unit.sprite.get_material())
	level.text = str("L", unit.type.level)
	type.text = str(unit.type.ID)
	race.text = str(unit.type.race)

	defense.text = str(unit.get_defense())  + "%"
	defense.modulate = _get_defense_color(unit.get_defense())

	hp.update_stat(unit.health_current, unit.type.health)
	xp.update_stat(unit.experience_current, unit.type.experience)
	mp.update_stat(unit.moves_current, unit.type.moves)

	alignment.text = str("%s (+%d%s)" % [unit.type.alignment, 0,"%"])

	for attack in unit.type.get_attacks():
		_add_attack_plate(attack)

func clear_unit() -> void:
	_fade_out()
	unit_name.text = "-"

	level.text = "-"
	type.text = "-"
	race.text = "-"

	hp.clear()
	xp.clear()
	mp.clear()

	alignment.text = "-"

	defense.text = "-"
	for plate in attacks.get_children():
		plate.clear()

func _fade_in() -> void:
	tween.interpolate_property(self, "modulate", modulate, Color("ffffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _fade_out() -> void:
	tween.interpolate_property(self, "modulate", modulate, Color("00ffffff"), 0.2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func _add_attack_plate(attack: Attack) -> void:
	var plate = AttackPlate.instance()
	attacks.add_child(plate)
	plate.update_attack(attack)

func _clear_attack_plates():
	for plate in attacks.get_children():
		plate.queue_free()

func _get_defense_color(defense: int) -> Color:
	var mod = float(defense) * 0.01
	var r = 1.0 - (1.0 * mod)
	var g = 1.0 * mod
	return Color(r, g, 0.0)