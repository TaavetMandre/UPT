extends AnimationPlayer

@export var ground: Node3D
@export var outdoor_camera: Node3D
@export var animation_camera: Camera3D

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

func toggle_camera_controls(state: bool) -> void:
	if outdoor_camera:
		outdoor_camera.can_move = state

func swap_camera_to_fake(reverse: bool) -> void:
	if outdoor_camera:
		for child in outdoor_camera.get_children():
			if child.name.to_lower() == "camera3d":
				child.current = reverse
				animation_camera.current = !reverse

func move_animation_camera_to_current_position() -> void: # useless right now
	if animation_camera:
		outdoor_camera.reset_rotation()


func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("cast"):
			#$AnimationTree["parameters/playback"].travel("death")
			play("death")
