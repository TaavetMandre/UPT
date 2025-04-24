extends Control

signal game_ready

@onready var button = $Button
@onready var screen = %Clouds
@export var camera_out_node: Node
@export var camera_in_node: Node
var camera_out: Camera3D
var camera_in: Camera3D

var dissolve_amount: float = 0.0
var burn_amount: float = 0.1
var noise_texture
var noise
var current_camera := "in" # in or out

func _ready():
	if camera_in_node:
		camera_in = camera_in_node.find_child("Camera3D", true) # match exact name (Camera3D) and do it recursively (true)
		
		if !camera_in:
			push_warning("could not find a camera in camera_in_node, camera switching will not work")
	else:
		push_warning("camera_in_node not set, camera switching will not work")
	
	if camera_out_node:
		camera_out = camera_out_node.find_child("Camera3D", true)
		
		if !camera_out:
			push_warning("could not find a camera in camera_out_node, camera switching will not work")
	else:
		push_warning("camera_out_node not set, camera switching will not work")

@warning_ignore("unused_parameter")
func _process(delta):
	screen.material.set("shader_parameter/dissolve_value", dissolve_amount)
	screen.material.set("shader_parameter/burn_size", burn_amount)

func randomize_noise():
	noise_texture = NoiseTexture2D.new()
	noise = FastNoiseLite.new()
	noise.seed = randi_range(0, 100)
	noise.noise_type = FastNoiseLite.TYPE_VALUE_CUBIC
	noise_texture.noise = noise
	screen.material.set("shader_parameter/dissolve_texture", noise_texture)

func toggle_camera(state: String):
	match state:
		"out":
			camera_out.current = true
			camera_out.enable()
			camera_in.current = false
			current_camera = "out"
			return
		"in":
			camera_out.current = false
			camera_in.current = true
			current_camera = "in"
			return
	push_warning(state, " is not a valid state for the camera")

func switch_camera_to(state: String): ## state "in" or "out"
	$AudioStreamPlayer.play()
	dissolve_amount = 0.0
	randomize_noise()
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "dissolve_amount", 1, 2.0)
	tween.tween_property(self, "burn_amount", 0, 1.0).set_delay(1)

	await get_tree().create_timer(2.0).timeout
	if camera_in and camera_out:
		toggle_camera(state)
		game_ready.emit()

	randomize_noise()
	
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel()
	tween.tween_property(self, "dissolve_amount", 0, 2.0)
	tween.tween_property(self, "burn_amount", 0.1, 1.0)
	
	await get_tree().create_timer(2).timeout
	$"../AnimationPlayer".play("outdoor")
