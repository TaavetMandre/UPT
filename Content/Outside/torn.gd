extends Node3D

@export var HP: int = 10
var maxhp: int

func _ready():
	maxhp = HP

func damaged(dam):
	HP -= dam
	if HP >= 0:
		GameMaster.DEATH()
	else:
		pass #update UI hp texture bar
func renew():
	HP = maxhp
