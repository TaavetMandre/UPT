extends AnimationPlayer

@export var ground: Node3D

func set_reverb_dialogue(state: bool) -> void:
	var bus_index = AudioServer.get_bus_index("dialogue")
	AudioServer.set_bus_effect_enabled(bus_index, 0, state)

func toggle_fog_mesh(state: bool) -> void:
	if ground:
		for child in ground.get_children():
			if child.name.to_lower() == "udu":
				child.visible = state
	else:
		push_warning("Set the ground node for intro AnimationPlayer")
