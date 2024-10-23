class_name HoverParticles extends GPUParticles2D

@onready var button: BaseButton = $".."
@onready var pink_blue = $"Pink-Blue"

func _ready():
	# Sets the size of the blue-pink particles to be the size of the button
	process_material.emission_shape_scale = Vector3(button.size.x / 2, button.size.y / 2, 1)
	process_material.emission_shape_offset = Vector3(button.size.x / 2, button.size.y / 2, 1)
	# Same as the above but for the pink-blue particles
	pink_blue.process_material.emission_shape_scale = Vector3(button.size.x / 2, button.size.y / 2, 1)
	pink_blue.process_material.emission_shape_offset = Vector3(button.size.x / 2, button.size.y / 2, 1)

func self_destruct():
	emitting = false
	pink_blue.emitting = false
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "self_modulate:a", 0, 0.5)
	tween.tween_property(self, "pink_blue:self_modulate:a", 0, 0.5)
