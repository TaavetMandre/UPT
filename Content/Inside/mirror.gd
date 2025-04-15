extends Node3D

@export var player: Node3D
@onready var interaction_area = $InteractionArea
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	if player:
		player.interact.connect(interact)
	else:
		print("Set a player in Mirror node")
		push_warning("Set a player in Mirror node")


func interact() -> void:
	for body in interaction_area.get_overlapping_bodies():
		if body.get_parent() == player: # The player node is a parent of the body that the area collides with
			print("interacted")
			animation.play("reveal")
