extends CanvasLayer
"""THIS SCRIPT IS WAITING FOR GLOBAL VARIABLES AND A MAIN SCENE"""
@onready var camera = $"../Camera"

func _input(event):
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.pressed:
		camera.dragging = false
		camera.rotating = false
		get_tree().paused = true
		var settings_scene = load("res://Content/UI/Pause/Pause.tscn").instantiate()
		add_child(settings_scene)
