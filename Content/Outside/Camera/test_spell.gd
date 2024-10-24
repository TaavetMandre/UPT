extends Node3D
@onready var spell_area = $spell_area


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("cast"):
		print("AAA")
		for i in spell_area.get_overlapping_bodies():
			print(i)
			i.damaged(50)
