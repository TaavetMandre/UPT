extends Node

#@onready var environment = %WorldEnvironment
#@onready var sun = %Sun
#@onready var moon = %Moon
#
#var morning = {
	#"name": "morning",
	#"sun_rotation": Vector3(deg_to_rad(-170), deg_to_rad(150), deg_to_rad(0)), # Angle of the sun
	#"sun_light_color": "ffee00",
	#"sun_light_energy": 1,
	#
	#"moon_rotation": Vector3(deg_to_rad(-190), deg_to_rad(150), deg_to_rad(0)),
	#"moon_light_energy": 0,
	#
	#"fog_enabled": false,
	#"fog_density": 0, # make this 0 before turning off the fog
	#"fog_light_energy": 0,
	#"sky_top_color": "7a95f5",
	#"sky_horizon_color": "ff8000"
#}
#
#var day = {
	#"name": "day",
	#"sun_rotation": Vector3(deg_to_rad(-115), deg_to_rad(150), deg_to_rad(0)), # Angle of the sun
	#"sun_light_color": "ffeeab",
	#"sun_light_energy": 1,
	#
	#"moon_rotation": Vector3(deg_to_rad(-295), deg_to_rad(150), deg_to_rad(0)),
	#"moon_light_energy": 0,
	#
	#"fog_enabled": false,
	#"fog_density": 0,
	#"fog_light_energy": 0,
	#"sky_top_color": "7a95f5",
	#"sky_horizon_color": "7a95f5"
#}
#
#var evening = {
	#"name": "evening",
	#"sun_rotation": Vector3(deg_to_rad(-10), deg_to_rad(150), deg_to_rad(0)), # Angle of the sun (-10, 150, 0)
	#"sun_light_color": "ff8a00",
	#"sun_light_energy": 1,
	#
	#"moon_rotation": Vector3(deg_to_rad(-200), deg_to_rad(150), deg_to_rad(0)),
	#"moon_light_energy": 0,
	#
	#"fog_enabled": false,
	#"fog_density": 0,
	#"fog_light_energy": 0,
	#"sky_top_color": "1b2673",
	#"sky_horizon_color": "d28a00"
#}
#
#var night = {
	#"name": "night",
	#"sun_rotation": Vector3(deg_to_rad(-200), deg_to_rad(150), deg_to_rad(0)), # Angle of the sun
	#"sun_light_color": "ff8a00",
	#"sun_light_energy": 0,
	#
	#"moon_rotation": Vector3(deg_to_rad(-65), deg_to_rad(150), deg_to_rad(0)), # Angle of the moon
	#"moon_light_energy": 0.5,
	#
	#"fog_enabled": true, # makes the night darker
	#"fog_density": 0.04,
	#"fog_light_energy": 0,
	#"sky_top_color": "111111",
	#"sky_horizon_color": "111111"
#}

#@export var state_switch_speed = 0.001  # the rate at which all settings change
var times_of_day: Array[String] = ["morning2", "day", "evening", "night2"]
@export var current_time: String

func cycle_current_time(): # changes the current time
	current_time = times_of_day.pop_front()
	times_of_day.append(current_time)
	%AnimationTree["parameters/playback"].travel(current_time)
	#create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT).tween_method(cycle_time.bind(current_time), 0.01, 1, 5)

func change_time_to(state: String):
	%AnimationTree["parameters/playback"].travel(state)


#func cycle_time(lerp_speed: float, time_dict: Dictionary):
	#if time_dict:
		## SUN
		#
		### Rotation using quaternions
		#var sun_quaternion = Quaternion(sun.transform.basis).normalized()  # converts the current rotation to a quaternion
		#var dict_quaternion = Quaternion.from_euler(time_dict["sun_rotation"]).normalized()  # same thing but with the wanted result
		#var result_quaternion = sun_quaternion.slerp(dict_quaternion, lerp_speed)  # spherical lerp
		#sun.transform.basis = Basis(result_quaternion)
		#
		### Rotation using interpolation (because only rotation.x is getting interpolated)
		##sun.rotation = sun.rotation.lerp_rotation(time_dict["sun_rotation"], lerp_speed)
		##sun.rotation = (sun.rotation + (time_dict["sun_rotation"] - sun.rotation) * lerp_speed)  # inretpolation
		#
		### Color
		#sun.light_color = sun.light_color.lerp(time_dict["sun_light_color"], lerp_speed)
		#
		### Energy
		#sun.light_energy = interpolate(sun.light_energy, time_dict["sun_light_energy"], lerp_speed)
		#if sun.light_energy < 0.01:
			#sun.visible = false
		#else:
			#sun.visible = true
		#
		## MOON
		#
		### Rotation using quaternions
		#var moon_quaternion = Quaternion(moon.transform.basis).normalized()  # converts the current rotation to a quaternion
		#var dict_quaternion_moon = Quaternion.from_euler(time_dict["moon_rotation"]).normalized()  # same thing but with the wanted result
		#var result_quaternion_moon = moon_quaternion.slerp(dict_quaternion_moon, lerp_speed)  # spherical lerp
		#moon.transform.basis = Basis(result_quaternion_moon)
		#
		### Energy
		#moon.light_energy = interpolate(moon.light_energy, time_dict["moon_light_energy"], lerp_speed)
		#if moon.light_energy < 0.01:
			#moon.visible = false
		#else:
			#moon.visible = true
		#
		## ENVIRONMENT
		#
		### Fog
		#var fog_boolean = time_dict["fog_enabled"]
		#if environment.environment.fog_density < 0.0001 and !fog_boolean:
			#environment.environment.fog_density = 0
			#environment.environment.fog_enabled = fog_boolean
		#elif environment.environment.fog_density > 0.00011 and fog_boolean:
			#environment.environment.fog_enabled = fog_boolean
		#
		#environment.environment.fog_density = interpolate(environment.environment.fog_density, time_dict["fog_density"], lerp_speed)
		#
		### Sky
		#environment.environment.sky.sky_material.sky_top_color = environment.environment.sky.sky_material.sky_top_color.lerp(time_dict["sky_top_color"], lerp_speed)
		#environment.environment.sky.sky_material.sky_horizon_color = environment.environment.sky.sky_material.sky_horizon_color.lerp(time_dict["sky_horizon_color"], lerp_speed)
#
##@warning_ignore("unused_parameter")
##func _process(delta):
	##if current_time:
		##cycle_time(current_time, state_switch_speed)
		###print(current_time.get("name", "x"))
#
#func interpolate(from, to, weight):
	## Custom float lerp
	#return Vector2(from, 0).lerp(Vector2(to, 0), weight)[0]

func _on_button_pressed():
	cycle_current_time()
