extends AnimationPlayer


func set_reverb_dialogue(state: bool) -> void:
	var bus_index = AudioServer.get_bus_index("dialogue")
	AudioServer.set_bus_effect_enabled(bus_index, 0, state)
