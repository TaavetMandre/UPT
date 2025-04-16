extends Node3D

@export var damage: int = 3
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player_3d = $AudioStreamPlayer3D

func _ready():
	position.y += 2.5
	audio_stream_player_3d.pitch_scale += randf_range(-0.05, 0.05)
	animation_player.play("Wave")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	queue_free()


func _on_hurtbox_area_body_entered(body):
	body.damaged(damage)
