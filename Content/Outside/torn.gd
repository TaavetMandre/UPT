extends StaticBody3D

@onready var GameMaster = $".."
@export var HP: int = 20
var maxhp: int

@onready var damage_particle: PackedScene = preload("res://Content/Other/damage particles.tscn")

func _ready():
	maxhp = HP

func damaged(dam):
	HP -= dam
	
	var particle = damage_particle.instantiate()
	particle.damage_amount = dam
	particle.color = Color("39b08b")
	add_child(particle)
	
	if HP <= 0:
		GameMaster.DEATH()
	else:
		print("ai") #update UI hp texture bar
func renew():
	HP = maxhp
