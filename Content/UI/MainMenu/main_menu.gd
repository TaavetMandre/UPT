extends Node

@onready var black_fade = %BlackFade
@export var play_button_scene: PackedScene  ## Main scene to transition to
#@export var settings_scene: PackedScene

## 3D
@onready var sub_viewport_container = $SubViewportContainer
@onready var sub_viewport = $SubViewportContainer/SubViewport
@onready var animation_player = %AnimationPlayer
@onready var extra_anim_player = %ExtraAnimPlayer

@export var main_gradient: Gradient
@export var settings_gradient: Gradient

func _ready():
	get_tree().get_root().size_changed.connect(resize) # window size change signal
	resize()
	
	%Title.size = Vector2(663, 175)
	%VBoxContainer.size = Vector2(1000, 706)
	
	animation_player.play("RESET")
	animation_player.play("Intro")
	await get_tree().create_timer(5).timeout
	animation_player.play("loop")

func _process(delta):
	#print(rad_to_deg(%tekstuurita_torn1_0.rotation.y), " ", rad_to_deg(%tekstuurita_torn1_0.rotation.y + PI))
	pass

func _on_play_button_pressed():
	extra_anim_player.play("play")
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	get_tree().change_scene_to_packed(play_button_scene)

func _on_settings_button_pressed():
	$"Main Menu/VBoxContainer/MenuSettings".load_states_from_global()

	
	var new_position = wrap(animation_player.current_animation_position + animation_player.current_animation_length / 2, # move the animation ahead by half of the length
							0, animation_player.current_animation_length) # prevents overflow
	
	# save the curernt state to apply before tweening
	var rotation = %tekstuurita_torn1_0.rotation.y
	var new_color = settings_gradient.sample(new_position / animation_player.current_animation_length)  # sample the new color based on the position of the animation
	
	extra_anim_player.play("goto_settings")
	
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(%WorldEnvironment, "environment:fog_light_color", new_color, 1.0)
	tween.tween_property(%tekstuurita_torn1_0, "rotation:y", rotation + PI, 1.0)
	
	await get_tree().create_timer(1.0).timeout
	
	animation_player.play_backwards("settings_loop")
	animation_player.seek(new_position)

func _on_back_button_pressed():
	var new_position = wrap(animation_player.current_animation_position + animation_player.current_animation_length / 2, # move the animation ahead by half of the length
							0, animation_player.current_animation_length) # prevents overflow
	
	# save the curernt state to apply before tweening
	var rotation = %tekstuurita_torn1_0.rotation.y
	var new_color = main_gradient.sample(new_position / animation_player.current_animation_length)  # sample the new color based on the position of the animation
	
	extra_anim_player.play("gofrom_settings")
	
	var tween = create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(%WorldEnvironment, "environment:fog_light_color", new_color, 1.0)
	tween.tween_property(%tekstuurita_torn1_0, "rotation:y", rotation + PI, 1.0)
	
	await get_tree().create_timer(1.0).timeout
	
	animation_player.play_backwards("loop")
	animation_player.seek(new_position)

func _on_quit_button_pressed():
	get_tree().quit()

func resize():
	#sub_viewport.size = get_window().size
	#sub_viewport_container.size = get_window().size
	pass

