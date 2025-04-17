extends Node3D

@export var player: Node3D
@onready var interaction_area = $InteractionArea
@onready var animation = $AnimationPlayer
@onready var key_prompt = $Sprite3D


# Called when the node enters the scene tree for the first time.
func _ready():
	key_prompt.visible = false
	if player:
		player.interact.connect(interact)
	else:
		print("Set a player in Mirror node")
		push_warning("Set a player in Mirror node")


func interact() -> void:
	for body in interaction_area.get_overlapping_bodies():
		if body.get_parent() == player: # The player node is a parent of the body that the area collides with
			animation.play("reveal")
			key_prompt.visible = false
			interaction_area.monitoring = false


func _on_interaction_area_body_entered(body):
	if body.get_parent() == player:
		key_prompt.visible = true


func _on_interaction_area_body_exited(body):
	if body.get_parent() == player:
		key_prompt.visible = false
