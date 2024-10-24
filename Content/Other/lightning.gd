extends Node3D

@onready var sparks = $Explosion/Sparks
@onready var smoke = $Explosion/Smoke
@onready var fire = $Explosion/Fire
@onready var lightning = $Lightning
@onready var lightning_windup = $LightningWindup

func _ready():
	await get_tree().create_timer(5).timeout
	lightning_windup.emitting = true
	await get_tree().create_timer(1.5).timeout
	lightning.emitting = true
	fire.emitting = true
	sparks.emitting = true
	smoke.emitting = true
