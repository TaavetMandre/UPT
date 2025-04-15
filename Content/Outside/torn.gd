extends StaticBody3D

@onready var GameMaster = $".."
@export var HP: int = 10
var maxhp: int

func _ready():
	maxhp = HP

func damaged(dam):
	HP -= dam
	if HP <= 0:
		GameMaster.DEATH()
	else:
		print("ai") #update UI hp texture bar
func renew():
	HP = maxhp
