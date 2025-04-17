extends Control

@onready var blur = $Blur
@onready var lod = blur.material.get_shader_parameter("Lod")
#@onready var bottom_particles = $BottomParticles
@onready var sidebar = $Sidebar
@onready var fade_to_menu = %BlackFade # Black fade when the player presses the menu button
@onready var label = $Sidebar/Label

func _ready():
	$MenuBar.position = Vector2(get_window().size.x + 777, 240)
	
	# unlock the camera
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Set up the ui elements
	sidebar.position.x -= get_viewport().get_visible_rect().size[0] / 3 # move the sidebar 0.3 screens to the left
	#bottom_particles.modulate.a = 0 # make the particles invisible
	
	# Initial animation
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true) 
	# Blur effect fading in
	tween.tween_property(self, "lod", 1, 0.5) 
	# Sidebar coming in from the left
	tween.tween_property(self, "sidebar:position:x", sidebar.position.x + get_viewport().get_visible_rect().size[0] / 3, 0.6)
	## Fading the particles in
	#tween.tween_property(self, "bottom_particles:modulate:a", 1, 0.6)
	
	# Enable the buttons once the tweening is done
	await get_tree().create_timer(0.6).timeout
	get_tree().call_group("pause_main", "enable_button_controls")

@warning_ignore("unused_parameter") # we dont need delta for this
func _process(delta):
	blur.material.set_shader_parameter("Lod", lod) # _process() needs to update the blur shader constantly otherwise it wouldnt work

## pause_main
func _on_continue_button_pressed():
	# Disables the visible keys and moves them up
	get_tree().call_group("pause_main", "disable_button_controls")
	get_tree().call_group("pause_main", "move_up")
	
	create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).tween_property($MenuBar, "position", Vector2(get_window().size.x + 777, 240), 0.5)
	
	#bottom_particles.emitting = false # Disables the bottom particles
	
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	# Unblur
	tween.tween_property(self, "lod", 0, 0.6)
	# Move the sidebar 0.3 screens to the left
	tween.tween_property(self, "sidebar:position:x", sidebar.position.x - get_viewport().get_visible_rect().size[0] / 3, 0.6)
	## Fade all particles away
	#tween.tween_property(self, "bottom_particles:modulate:a", 0, 0.6)
	# Fade the text away
	tween.tween_property(self, "label:modulate:a", 0, 0.3)
	
	await get_tree().create_timer(0.6).timeout
	queue_free()
	get_tree().paused = false

func _on_settings_button_pressed():
	#get_tree().call_group("pause_main", "disable_button_controls") # Switches the click checking on the buttons to be appropriate
	#get_tree().call_group("pause_settings", "enable_button_controls")
	#get_tree().call_group("pause_main", "quit_buttons", 1000) # int is the final y position in the sidebar
	#get_tree().call_group("pause_settings", "quit_buttons", 300)
	label.text = "SETTINGS"
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).tween_property($MenuBar, "position", Vector2(777, 240), 1)

func _on_menu_button_pressed():
	get_tree().call_group("pause_main", "disable_button_controls") # Disable all of the buttons so they dont detect the mouse or escape keys anymore
	# Fade the screen to black and switch the scene to menu scene
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "fade_to_menu:modulate:a", 1, 0.5)
	
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://Content/UI/MainMenu/main_menu.tscn")
	queue_free()

func _on_quit_button_pressed():
	get_tree().call_group("pause_main", "disable_button_controls") # Switches the click checking on the buttons to be appropriate
	get_tree().call_group("pause_quit", "enable_button_controls")
	get_tree().call_group("pause_main", "quit_buttons", 1000) # int is the final y position in the sidebar
	get_tree().call_group("pause_quit", "quit_buttons", 300)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "label:position:x", 3300, 0.5)
	label.text = "ARE YOU SURE?"

## pause_quit
func _on_quit_yes_pressed():
	get_tree().call_group("pause_main", "disable_button_controls") # Disable all of the buttons so they dont detect the mouse or escape keys anymore
	# Fade the screen to black and close the game
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "fade_to_menu:modulate:a", 1, 0.5)
	tween.tween_callback(get_tree().quit)

func _on_quit_no_pressed():
	get_tree().call_group("pause_main", "enable_button_controls") # Switches the click checking on the buttons to be appropriate
	get_tree().call_group("pause_quit", "disable_button_controls")
	get_tree().call_group("pause_main", "quit_buttons", 300) # int is the final y position in the sidebar
	get_tree().call_group("pause_quit", "quit_buttons", 1000)
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "label:position:x", 3150, 0.5)
	label.text = "PAUSED"

## pause_settings

