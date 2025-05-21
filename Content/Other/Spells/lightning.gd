extends Node3D

@export var damage: int = 5

@onready var sparks = $Explosion/Sparks
@onready var smoke = $Explosion/Smoke
@onready var fire = $Explosion/Fire
@onready var lightning = $Lightning
@onready var lightning_windup = $LightningWindup

@onready var hurtbox = $"Hurtbox Area"

@onready var windup_sound = $"Windup Sound"
@onready var explosion_sound = $"Explosion Sound"

@onready var indicator = $Indicator
var indicator_intensity: float = 5.0

func _process(delta):
	indicator.mesh.material.set("shader_parameter/emission_amount", indicator_intensity)

func _ready():
	lightning_windup.emitting = true
	
	await get_tree().create_timer(0.5).timeout
	windup_sound.pitch_scale = 1 + randf_range(-0.05, 0.05)
	windup_sound.play()
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.tween_property(self, "indicator_intensity", 0, 1)
	
	await get_tree().create_timer(1).timeout
	explosion_sound.play()
	indicator.visible = false
	
	# flash the hurtbox for a frame probably? ---- no just keep enabled and damage once.
	for i in hurtbox.get_overlapping_bodies():
		i.damaged(damage)
		
	
	lightning.emitting = true
	fire.emitting = true
	sparks.emitting = true
	smoke.emitting = true
	
	await get_tree().create_timer(5).timeout
	queue_free()
