extends RayCast3D

@onready var test_spell = $"../test_spell"
@onready var top_camera = $"../TopCamera"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.y = top_camera.position.y
	test_spell.position.y = get_collision_point().y
