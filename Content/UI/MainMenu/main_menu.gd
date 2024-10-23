extends Control

@onready var black_fade = %BlackFade

func _ready():
	var tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "black_fade:modulate:a", 0, 0.5)

func _on_play_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Content/TEMPORARYSCENES/node_3d.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://Content/UI/MainMenu/settings.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
