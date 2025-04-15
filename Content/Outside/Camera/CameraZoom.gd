extends Camera3D
# var displacement2 = Vector2(3, 3*tan(15*PI/180)) # the 2d version of camera zoom movement

# Highest and lowest y values used for zoom
@export var highest_height = 50
@export var lowest_height = 25
@export_range(1, 50) var zoom_sensitivity = 10 # currently has to be changed in the script

## Passed down from the scene parent
@export var map_visibility_restriction_plane: MeshInstance3D

@onready var restriction_ray = $RestrictionRay

var displacement3 := Vector3(0, zoom_sensitivity, zoom_sensitivity * tan(deg_to_rad(rotation_degrees.x+90))) # the 3d version of camera zoom movement

func _process(delta):
	if map_visibility_restriction_plane:
		map_visibility_restriction_plane.global_position.y = self.global_position.y - 5

func zoom_in(length:=0.0):
	var zoom_distance := Vector3.ZERO
	if length == 0.0: zoom_distance = displacement3
	else: zoom_distance = Vector3(0, length, length * tan(rotation.x + PI/2))
	
	if !restriction_ray.is_colliding():
		var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		# Checks the height before zooming
		if position - zoom_distance < Vector3(position.x, lowest_height, position.z): # correction to lowest limit
			tween.kill()
			var tween2 = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			tween2.tween_property(self, "position", Vector3(position.x, lowest_height, position.z + (lowest_height-position.y)*tan(deg_to_rad(rotation_degrees.x+90))), 0.5)
		
		tween.tween_property(self, "position", position - zoom_distance, 0.5)

func zoom_out(length:=0.0):
	var zoom_distance := Vector3.ZERO
	if length == 0.0: zoom_distance = displacement3
	else: zoom_distance = Vector3(0, length, length * tan(rotation.x + PI/2))
	
	var tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	# Checks the height before zooming
	if position + zoom_distance > Vector3(position.x, highest_height, position.z): # correction to highest limit
		tween.kill()
		var tween2 = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween2.tween_property(self, "position", Vector3(position.x, highest_height, position.z + (highest_height-position.y)*tan(deg_to_rad(rotation_degrees.x+90))), 0.5)
	
	tween.tween_property(self, "position", position + zoom_distance, 0.5)

func _input(event):
	if event is InputEventMouseButton and event.button_index == 4: # Scroll up detection
		if position.y > lowest_height:
			zoom_in()
	if event is InputEventMouseButton and event.button_index == 5: # Scroll down detection
		if position.y < highest_height:
			zoom_out()
