extends Path3D

@onready var koht = $PathFollow3D

@export var mob: PackedScene
@export var master: Node

func _ready():
	pass # Replace with function body.

func spawn(amount: int, state: int):
	if amount != 0:
		if amount > 6:
			for i in range(6):
				koht.progress_ratio = float(i)/float(6-1)
				create(state)
			await get_tree().create_timer(5).timeout
			spawn(amount-6, state)
		else:
			for i in range(amount):
				koht.progress_ratio = float(i)/float(amount-1)
				create(state)

func create(state: int):
	var individ = mob.instantiate()
	individ.position = koht.position
	individ.start_state = state
	individ.master = master
	add_child(individ)

