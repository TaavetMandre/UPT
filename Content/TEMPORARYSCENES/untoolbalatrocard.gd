extends Sprite2D

signal show_indicator
signal deploy_spell
signal hide_indicator
signal disable_camera_dragging

@export var card_show_area: Control
@export var spell_scene: PackedScene
@export var indicator_scene: PackedScene
@export var ground: Node
@export var camera: Node
var hover
var click_pressed
var is_called = false
var has_called_bar = false
var zero_position: Vector2 = Vector2.ZERO

func _ready():
	get_tree().get_root().size_changed.connect(resize) # window size change signal
	position.y = get_window().size.y - 75
	zero_position = position

func resize():
	position.y = get_window().size.y - 75
	zero_position = position

@warning_ignore("unused_parameter")
func _process(delta):
	#print("zero = " + str(zero_position) + " position = " + str(round(position / 10) * 10), str(position))
	
	if hover == true or click_pressed:
		material.set_shader_parameter("mouse_position", get_global_mouse_position())
		material.set_shader_parameter("sprite_position", global_position)
	elif hover == false:
		var reset_to_straight = lerp(material.get_shader_parameter("mouse_position"), global_position, 0.1)
		material.set_shader_parameter("mouse_position", reset_to_straight)
		material.set_shader_parameter("sprite_position", global_position)
	
	#print(click_pressed, round(position * 10) / 10 != zero_position)
	
	if click_pressed:
		disable_camera_dragging.emit()
		position = lerp(position, get_global_mouse_position(), 0.1)
	elif round(position / 10) * 10 != zero_position:
		position = lerp(round(position), zero_position, 0.15)
	#else:
	#	position = zero_position
	
	if position.y <= card_show_area.position.y:
		modulate.a = 0
		if !has_called_bar:
			get_tree().call_group("cardbar", "lower_bar")
			has_called_bar = true
		show_indicator.emit(self)
	elif position.y > card_show_area.position.y:
		modulate.a = 1
		if has_called_bar:
			get_tree().call_group("cardbar", "raise_bar")
			has_called_bar = false
			if !click_pressed:
				deploy_spell.emit(self)
			else:
				hide_indicator.emit(self)

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

func flip_is_called():
	is_called = !is_called
