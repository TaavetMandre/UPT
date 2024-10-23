extends Node3D
"""
Camera movement script

Camera zooming is in Assets/Content/Outside/Camera/CameraZoom.gd
ln40 - change min and max camera speed (multiplied by movement_sensitivity)
"""
@onready var top_camera = $TopCamera
## Changes the sensitivity of camera movement
@export_range(0.1, 1.0) var movement_sensitivity = 0.5
@export var dragging:bool = false # for left click detection and camera movement with the mouse
@export var rotating:bool = false # for right click detection and camera rotation

var previous_frame_mouse_position = Vector2(0, 0) # the position of the mouse in the last frame, used to calculate camera movement with the mouse
@export var WASDVectorpos = Vector3(0, 0, 0)
@export var WASDVectorneg = Vector3(0, 0, 0)

# speed at max height - 15; speed at min height - 5, shifting reduces the speed; note: the speed is used in division
#var speed: float = 0.0

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1: # Left click detection
		dragging = event.pressed
	if event is InputEventMouseButton and event.button_index == 2: # Right click detection
		rotating = event.pressed
	
	# WASD detection
	if event is InputEventKey: # Keyboard detection
		match event.keycode:
			KEY_W:
				WASDVectorpos.z = int(event.pressed)
			KEY_A:
				WASDVectorpos.x = int(event.pressed)
			KEY_S:
				WASDVectorneg.z = int(event.pressed)
			KEY_D:
				WASDVectorneg.x = int(event.pressed)

@warning_ignore("unused_parameter")
func _process(delta):
	if dragging: # Mouse camera movement
		var speed = 15 - (10 * (top_camera.position.y-top_camera.lowest_height)/(top_camera.highest_height-top_camera.lowest_height)) # used to make mouse movement slower if the camera is more zoomed in, (value-min)/(max-min) => convert value to a 0-1 range
		var position_difference = (previous_frame_mouse_position - get_viewport().get_mouse_position()).rotated(PI - rotation.y)
		var position_difference3 = Vector3(position_difference.x, 0, position_difference.y)
		
		if position_difference != Vector2(0, 0): # The if condition checks for movement to avoid creating unnecessary tweens
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC) # Smoothing
			tween.tween_property(self, "position", position - position_difference3 / speed * movement_sensitivity, 1)
	
	#if dragging:
		#if InputEventMouseMotion:
			#print((previous_frame_mouse_position - get_viewport().get_mouse_position()).rotated(PI - rotation.y))
			#print(Input.get_last_mouse_velocity())
	
	if rotating: # Camera rotation using right click
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		var mouse_movementx = previous_frame_mouse_position[0] - get_viewport().get_mouse_position()[0]
		tween.tween_property(self, "rotation:y", rotation.y + mouse_movementx / 10, 0.5) #rotation_degrees.y += previous_frame_mouse_position[0] - get_viewport().get_mouse_position()[0]
		tween.tween_callback(tween.kill)
	previous_frame_mouse_position = get_viewport().get_mouse_position()
	
	#WASD movement
	var WASDVector = (WASDVectorpos - WASDVectorneg).rotated(Vector3.UP ,rotation.y)
	if WASDVector and Input.is_key_pressed(KEY_SHIFT): # shift slows down the speed
		var speed = 15 - (10 * (top_camera.position.y - top_camera.lowest_height) / (top_camera.highest_height - top_camera.lowest_height)) # ln48
		var tweenWASD = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tweenWASD.tween_property(self, "position",
								position - WASDVector * 10 / speed / sqrt(WASDVector.dot(WASDVector)), 0.5)
	elif WASDVector:
		var speed = 5 - (2.5 * (top_camera.position.y - top_camera.lowest_height) / (top_camera.highest_height - top_camera.lowest_height)) # ln48
		var tweenWASD = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tweenWASD.tween_property(self, "position",
								position - WASDVector * 10 / speed / sqrt(WASDVector.dot(WASDVector)), 0.5)
