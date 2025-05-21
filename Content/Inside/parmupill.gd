extends Node3D

@export var random_audios: Array[AudioStream]
@export var player: Node3D

@onready var interaction_area = $InteractionArea
@onready var sound = $AudioStreamPlayer3D
@onready var key_prompt = $Sprite3D

func _ready():
	key_prompt.visible = false
	if player:
		player.interact.connect(interact)
	else:
		print("Set a player in Mirror node")
		push_warning("Set a player in Mirror node")


func randomize_sound():
	sound.stream = random_audios.pick_random()
	print(sound.stream)
	sound.pitch_scale = 1 + randf_range(-0.025, 0.025)


func interact() -> void:
	for body in interaction_area.get_overlapping_bodies():
		if body.get_parent() == player: # The player node is a parent of the body that the area collides with
			key_prompt.visible = false
			interaction_area.monitoring = false
			randomize_sound()
			sound.play()
			await get_tree().create_timer(2).timeout
			interaction_area.monitoring = true

func _on_interaction_area_body_entered(body):
	if body.get_parent() == player:
		key_prompt.visible = true


func _on_interaction_area_body_exited(body):
	if body.get_parent() == player:
		key_prompt.visible = false
