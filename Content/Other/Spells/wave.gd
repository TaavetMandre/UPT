extends Node3D

@export var damage: int = 3
@onready var animation_player = $AnimationPlayer

func _ready():
	position.y += 2.5
	animation_player.play("Wave")
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	queue_free()


func _on_hurtbox_area_body_entered(body):
	body.damaged(damage)
