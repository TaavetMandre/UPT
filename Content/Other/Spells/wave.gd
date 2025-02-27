extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	position.y += 2.5
	animation_player.play("Wave")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	queue_free()
