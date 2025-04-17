extends StaticBody3D

@onready var GameMaster = $".."
@export var HP: int = 20
var maxhp: int
@onready var health_bar = $"../Spell deploy bar/MarginContainer/VBoxContainer/Hp"

@onready var damage_particle: PackedScene = preload("res://Content/Other/damage particles.tscn")
@onready var hurt_sound = $AudioStreamPlayer3D
@export var HURT_SOUNDS: Array[AudioStream]


func _ready():
	maxhp = HP
	health_bar.max_value = HP
	health_bar.value = HP

func damaged(dam):
	HP -= dam
	
	var hurt_sound_file = HURT_SOUNDS.pick_random()
	hurt_sound.stream = hurt_sound_file
	hurt_sound.pitch_scale += randf_range(-0.05, 0.05)
	hurt_sound.play()
	hurt_sound.pitch_scale = 1
	
	var particle = damage_particle.instantiate()
	particle.damage_amount = dam
	particle.color = Color("00c244")
	add_child(particle)
	
	if HP <= 0:
		$CollisionShape3D.disabled = true # cant damage anymore (no numbers)
		health_bar.value = HP
		GameMaster.DEATH()
	else:
		health_bar.value = HP

func renew():
	HP = maxhp
