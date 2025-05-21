extends Node3D

@export var damage: int = 5

@onready var hurtbox = $"Hurtbox Area"
@onready var animation_player = $AnimationPlayer

@onready var cast_sound = $"Cast Sound"
@onready var windup_sound = $"Windup Sound"

func _ready():
	cast_sound.pitch_scale = 1 + randf_range(-0.05, 0.05)
	windup_sound.pitch_scale = 1 + randf_range(-0.05, 0.05)
	animation_player.play("cast")
	await animation_player.animation_finished
	queue_free()

func damage_enemies_in_area():
	for i in hurtbox.get_overlapping_bodies():
		i.damaged(damage)
