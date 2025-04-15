extends Node3D
"""
Camera movement script

Camera zooming is in Assets/Content/Outside/Camera/CameraZoom.gd
ln40 - change min and max camera speed (multiplied by movement_sensitivity)
"""
#@onready var lookat_ray = $CameraLookAtRay
#@onready var camera_ray = $Camera3D/CameraRay
#@onready var down_ray = $Camera3D/DownRay
@onready var restriction_ray = $Camera3D/RestrictionRay
@onready var restriction_ray_failsafe = $Camera3D/RestrictionRayFailsafe
@onready var camera_move_restriction_area = $Camera3D/CameraMoveRestrictionArea

var top_camera

## Changes the sensitivity of camera movement
@onready var movement_sensitivity = SettingsGlobal.outdoor_mouse_sensitivity
@onready var rotation_sensitivity = SettingsGlobal.outdoor_rotation_sensitivity
@export var dragging:bool = false # for left click detection and camera movement with the mouse
@export var rotating:bool = false # for right click detection and camera rotation
@export var map_visibility_restriction_plane: MeshInstance3D ## The mesh used to restrict visibility at the edges of the map
@export var out_of_bounds_area_list: Array[CollisionObject3D] ## CollisionObjects used at the edges of the world to direct the player back to the origin of the scene
@export var outdoor_ui: Array[Node]

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

func _ready():
	top_camera = %Camera3D
	var camera_distance_from_zero = top_camera.highest_height * sin(PI / 2 - top_camera.rotation.x)
	top_camera.position = Vector3(0, top_camera.highest_height, camera_distance_from_zero)
	
	# @export variables
	top_camera.map_visibility_restriction_plane = map_visibility_restriction_plane
	
	#
	#var lookat_ray_length = (top_camera.lowest_height - top_camera.highest_height) * 1 / cos(PI / 6)
	#lookat_ray.target_position = Vector3(0, lookat_ray_length, 0).rotated(Vector3(1, 0, 0), PI - PI / 3)
	#
	#camera_ray.target_position = Vector3(0, -top_camera.lowest_height, 0)

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
	if top_camera.current:
		for ui_element in outdoor_ui:
			ui_element.visible = true
	else:
		for ui_element in outdoor_ui:
			ui_element.visible = false
	
	var is_in_illegal_area = camera_move_restriction_area.has_overlapping_bodies()
	var is_out_of_bounds = camera_move_restriction_area.get_overlapping_bodies().any(func(x): return out_of_bounds_area_list.has(x))
	
	if top_camera.current and !is_out_of_bounds:
		#WASD movement
		#var WASDVector = (WASDVectorpos - WASDVectorneg).rotated(Vector3.UP ,rotation.y)
		var WASDVector = Vector3.ZERO
		WASDVector.x = -Input.get_action_strength("D_button") + Input.get_action_strength("A_button")
		WASDVector.z = -Input.get_action_strength("S_button") + Input.get_action_strength("W_button")
		WASDVector = WASDVector.rotated(Vector3.UP, rotation.y).normalized()
		#if is_in_illegal_area: WASDVector = -WASDVector
		
		if dragging and !WASDVector: # Mouse camera movement
			var speed = 15 - (10 * (top_camera.position.y-top_camera.lowest_height)/(top_camera.highest_height-top_camera.lowest_height)) # used to make mouse movement slower if the camera is more zoomed in, (value-min)/(max-min) => convert value to a 0-1 range
			#if is_in_illegal_area: speed = -speed # reverse direction if the camera is overlapping
			var position_difference = (previous_frame_mouse_position - get_viewport().get_mouse_position()).rotated(PI - rotation.y)
			var position_difference3 = Vector3(position_difference.x, 0, position_difference.y)
			
			if position_difference != Vector2(0, 0): # The if condition checks for movement to avoid creating unnecessary tweens
				var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC) # Smoothing
				tween.tween_property(self, "position", position - position_difference3 / speed * movement_sensitivity, 25 * delta)
				if is_in_illegal_area: tween.kill()
		
		#if dragging:
			#if InputEventMouseMotion:
				#print((previous_frame_mouse_position - get_viewport().get_mouse_position()).rotated(PI - rotation.y))
				#print(Input.get_last_mouse_velocity())
		
		if rotating and !is_in_illegal_area: # Camera rotation using right click
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			var mouse_movementx = previous_frame_mouse_position[0] - get_viewport().get_mouse_position()[0]
			tween.tween_property(self, "rotation:y", rotation.y + mouse_movementx / 10 * rotation_sensitivity, 50 * delta) #rotation_degrees.y += previous_frame_mouse_position[0] - get_viewport().get_mouse_position()[0]
			tween.tween_callback(tween.kill)
			if is_in_illegal_area: tween.kill()
		previous_frame_mouse_position = get_viewport().get_mouse_position()
		
		#if WASDVector and Input.is_key_pressed(KEY_SHIFT): # shift slows down the speed
			#var speed = 15 - (10 * (top_camera.position.y - top_camera.lowest_height) / (top_camera.highest_height - top_camera.lowest_height)) # ln48
			#var tweenWASD = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			#tweenWASD.tween_property(self, "position",
									#position - WASDVector * 10 / speed / sqrt(WASDVector.dot(WASDVector)), 0.5 * movement_sensitivity)
		if WASDVector and !dragging:
			var speed = 5 - (2.5 * (top_camera.position.y - top_camera.lowest_height) / (top_camera.highest_height - top_camera.lowest_height)) # ln48
			var tweenWASD = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tweenWASD.tween_property(self, "position",
									position - WASDVector * 10 / speed / sqrt(WASDVector.dot(WASDVector)) * movement_sensitivity, 0.5)
			if is_in_illegal_area: tweenWASD.kill()
		
		## Camera height restrictions
		#if down_ray.is_colliding():
			#var collision_point = down_ray.get_collision_point()
			#if collision_point.y + top_camera.highest_height < top_camera.global_position.y:
				#var height_difference = top_camera.highest_height - top_camera.lowest_height
				#top_camera.highest_height = top_camera.global_position.y - (collision_point.y + top_camera.highest_height)
				#top_camera.lowest_height = top_camera.global_position.y - (collision_point.y + top_camera.lowest_height)
				#top_camera.zoom_in()
	elif top_camera.current:
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		var position_to_origin: Vector3 = position.move_toward(Vector3.ZERO, 5)
		tween.tween_property(self, "position", position_to_origin, 60 * delta)
	
	if restriction_ray.is_colliding():
		top_camera.zoom_out(2.5)
	
	if restriction_ray_failsafe.is_colliding():
		var zoom_distance :float = abs(restriction_ray_failsafe.get_collision_point().y - top_camera.global_position.y) + 2.5
		top_camera.zoom_out(zoom_distance)

