@tool
extends TextureRect

var hover: bool = false

func _process(delta):
	if hover:
		material.set_shader_parameter("mouse_position", get_global_mouse_position())
		material.set_shader_parameter("sprite_position", global_position)
	else:
		material.set_shader_parameter("mouse_position", get_global_mouse_position())
		material.set_shader_parameter("sprite_position", global_position)
	print(get_global_mouse_position())


func _on_mouse_entered():
	hover = true

func _on_mouse_exited():
	hover = false
