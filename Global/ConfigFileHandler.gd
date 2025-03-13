extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"  # %APPDATA%\Godot\app_userdata\[project name]

func _ready():
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		print("Settings file not found, creating a new one at %s" % SETTINGS_FILE_PATH)
		config.set_value("Video", "framerate", 6) # unlimited
		config.set_value("Video", "vsync", 2) # enabled
		config.set_value("Video", "window_mode", 3) # borderless
		config.set_value("Video", "window_size", 5) # 16:9 1080p
		config.set_value("Video", "3d_render_scale", 1.0) # 1.0x
		
		config.set_value("Audio", "Master", 1.0)
		config.set_value("Audio", "Music", 1.0)
		config.set_value("Audio", "SFX", 1.0)
		config.set_value("Audio", "Dialogue", 1.0)
		
		config.set_value("General", "language", 0)
		config.set_value("General", "indoors_mouse_sensitivity_x", 1.0)
		config.set_value("General", "indoors_mouse_sensitivity_y", 1.0)
		config.set_value("General", "outdoor_mouse_sensitivity", 1.0)
		config.set_value("General", "outdoor_rotation_sensitivity", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		print("Loaded settings from %s to ConfigFileHandler" % SETTINGS_FILE_PATH)
		config.load(SETTINGS_FILE_PATH)

func save_video_setting(key: String, value):
	config.set_value("Video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_setting(key: String):
	return config.get_value("Video", key, 0)

func save_audio_setting(key: String, value):
	config.set_value("Audio", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_audio_setting(key: String):
	return config.get_value("Audio", key, 0)

func save_general_setting(key: String, value):
	config.set_value("General", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_general_setting(key: String):
	return config.get_value("General", key, 0)
