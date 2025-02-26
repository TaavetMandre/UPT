@tool
extends Sprite2D

var hover
var click_pressed
@onready var zero_position: Vector2 = position

func _process(delta):
	#print("zero = " + str(zero_position) + " position = " + str(position))
	print(zero_position != position, zero_position)
	if hover == true or click_pressed:
		material.set_shader_parameter("mouse_position", get_global_mouse_position())
		material.set_shader_parameter("sprite_position", global_position)
	elif hover == false:
		var reset_to_straight = lerp(material.get_shader_parameter("mouse_position"), global_position, 0.1)
		material.set_shader_parameter("mouse_position", reset_to_straight)
		material.set_shader_parameter("sprite_position", global_position)
	
	if click_pressed:
		position = lerp(position, get_global_mouse_position(), 0.1)
	elif position != zero_position:
		position = lerp(round(position), zero_position, 0.15)
	#else:
	# 	position = zero_position

#func _input(event):
	#if event is InputEventMouse:
		#if event.button_mask == 1 and hover and event.get("pressed"):
			#click_pressed = event.pressed
		#elif event.button_mask == 1 and !event.get("pressed"):
			#click_pressed = false

func _on_mouse_entered():
	hover = true

func _on_mouse_exited():
	hover = false

func _on_texture_rect_gui_input(event):
	#print(event)
	if event is InputEventMouse:
		if event.button_mask == 1 and hover and event.get("pressed"):
			click_pressed = event.pressed
		elif event.button_mask == 0:
			if event.get("pressure") != 1:
				click_pressed = false
