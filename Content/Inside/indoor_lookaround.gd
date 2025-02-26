extends Node3D

@export_category("Set by settings")
@export var x_sensitivity: float = SettingsGlobal.indoors_mouse_sensitivity_x  ## Look sensitivity set by SettingsGlobal
@export var y_sensitivity: float = SettingsGlobal.indoors_mouse_sensitivity_y  ## Look sensitivity set by SettingsGlobal

@export_category("Set in the editor")
@export var move_speed: float = 1.0  ## Player speed
@export var gravity: float = -50.0

@onready var camera = %Camera3D
@onready var player = $bean


func _process(delta):
	if camera.current:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # lock the mouse position to the center
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event):
	if camera.current:
		if event is InputEventMouseMotion:
			camera.rotation_degrees.x -= event.relative.y * x_sensitivity
			camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)  # -90 to 90 degrees
			
			camera.rotation_degrees.y -= event.relative.x * y_sensitivity
			camera.rotation_degrees.y = wrapf(camera.rotation_degrees.y, 0, 360)  # 0 to 360 degrees

func _physics_process(delta):
	if camera.current:
		var move_direction = Vector3.ZERO
		move_direction.x = Input.get_action_strength("D_button") - Input.get_action_strength("A_button")
		move_direction.z = Input.get_action_strength("S_button") - Input.get_action_strength("W_button")
		move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y).normalized()
		
		player.velocity.x = move_direction.x * move_speed
		player.velocity.z = move_direction.z * move_speed
		if !player.is_on_floor():
			player.velocity.y -= gravity * delta
		else:
			player.velocity.y = 0
		player.move_and_slide()
