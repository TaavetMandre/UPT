extends Node

@onready var knight_spawner_s = $Knight_spawner_S

var day = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	match day:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass
		7:
			pass
		8:
			pass
		9:
			pass
		10:
			pass
	knight_spawner_s.spawn(14, 0) #temp ver

#for enemyes 0 - tower
#            1 - other faction
#            2 - own leader

func DEATH():
	print("surm") # anim + time reset
