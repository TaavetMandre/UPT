extends GPUParticles3D

@export var damage_amount: int = 1
@export var color: Color = Color("ff583b")

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_pass_1.text = "-" + str(damage_amount)
	draw_pass_1.material.set("albedo_color", color)
	emitting = true


func _on_finished():
	queue_free()
