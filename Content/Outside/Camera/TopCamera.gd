extends Node3D
"""
Camera movement script

Camera zooming is in Assets/Content/Outside/Camera/CameraZoom.gd
ln40 - change min and max camera speed (multiplied by movement_sensitivity)
"""
@onready var top_camera = %Camera3D
## Changes the sensitivity of camera movement
@onready var movement_sensitivity = SettingsGlobal.outdoor_mouse_sensitivity
@onready var rotation_sensitivity = SettingsGlobal.outdoor_rotation_sensitivity
@export var dragging:bool = false # for left click detection and camera movement with the mouse
@export var rotating:bool = false # for right click detection and camera rotation

var previous_frame_mouse_position = Vector2(0, 0) # the position of the mouse in the last frame, used to calculate camera movement with the mouse
#@export var WASDVectorpos = Vector3(0, 0, 0)
#@export var WASDVectorneg = Vector3(0, 0, 0)

# speed at max height - 15; speed at min height - 5, shifting reduces the speed; note: the speed is used in division
#var speed: float = 0.0

func shoot_ray():
	var mouse_position = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = top_camera.project_ray_origin(mouse_position)
	var to = from + top_camera.project_ray_normal(mouse_position) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	var raycast_result = space.intersect_ray(ray_query)
	return raycast_result

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1: # Left click detection
		dragging = event.pressed
	if event is InputEventMouseButton and event.button_index == 2: # Right click detection
		rotating = event.pressed
	
	## WASD detection
	#if event is InputEventKey: # Keyboard detection
		#match event.keycode:
			#KEY_W:
				#WASDVectorpos.z = int(event.pressed)
			#KEY_A:
				#WASDVectorpos.x = int(event.pressed)
			#KEY_S:
				#WASDVectorneg.z = int(event.pressed)
			#KEY_D:
				#WASDVectorneg.x = int(event.pressed)

@warning_ignore("unused_parameter")
func _process(delta):
	if dragging: # Mouse camera movement
		var speed = 15 - (10 * (top_camera.position.y-top_camera.lowest_height)/(top_camera.highest_height-top_camera.lowest_height)) # used to make mouse movement slower if the camera is more zoomed in, (value-min)/(max-min) => convert value to a 0-1 range
		var position_difference = (previous_frame_mouse_position - get_viewport().get_mouse_position()).rotated(PI - rotation.y)
		var position_difference3 = Vector3(position_difference.x, 0, position_difference.y)
		
		if position_difference != Vector2(0, 0): # The if condition checks for movement to avoid creating unnecessary tweens
			var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC) # Smoothing
			tween.tween_property(self, "position", position - position_difference3 / speed * movement_sensitivity, 25 * delta)
	
	#if dragging:
		#if InputEventMouseMotion:
			#print((previous_frame_mouse_position - get_viewport().get_mouse_position()).rotated(PI - rotation.y))
			#print(Input.get_last_mouse_velocity())
	
	if rotating: # Camera rotation using right click
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		var mouse_movementx = previous_frame_mouse_position[0] - get_viewport().get_mouse_position()[0]
		tween.tween_property(self, "rotation:y", rotation.y + mouse_movementx / 10 * rotation_sensitivity, 50 * delta) #rotation_degrees.y += previous_frame_mouse_position[0] - get_viewport().get_mouse_position()[0]
		tween.tween_callback(tween.kill)
	previous_frame_mouse_position = get_viewport().get_mouse_position()
	
	#WASD movement
	#var WASDVector = (WASDVectorpos - WASDVectorneg).rotated(Vector3.UP ,rotation.y)
	var WASDVector = Vector3.ZERO
	WASDVector.x = -Input.get_action_strength("D_button") + Input.get_action_strength("A_button")
	WASDVector.z = -Input.get_action_strength("S_button") + Input.get_action_strength("W_button")
	WASDVector = WASDVector.rotated(Vector3.UP, rotation.y).normalized()
	#if WASDVector and Input.is_key_pressed(KEY_SHIFT): # shift slows down the speed
		#var speed = 15 - (10 * (top_camera.position.y - top_camera.lowest_height) / (top_camera.highest_height - top_camera.lowest_height)) # ln48
		#var tweenWASD = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		#tweenWASD.tween_property(self, "position",
								#position - WASDVector * 10 / speed / sqrt(WASDVector.dot(WASDVector)), 0.5 * movement_sensitivity)
	if WASDVector:
		var speed = 5 - (2.5 * (top_camera.position.y - top_camera.lowest_height) / (top_camera.highest_height - top_camera.lowest_height)) # ln48
		var tweenWASD = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tweenWASD.tween_property(self, "position",
								position - WASDVector * 10 / speed / sqrt(WASDVector.dot(WASDVector)) * movement_sensitivity, 0.5)
