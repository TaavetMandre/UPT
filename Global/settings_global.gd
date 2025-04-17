extends Node

## Video
var framerate_index: int # 6 - unlimited
var vsync_index: int # 2 - enabled
var window_mode_index: int # 3 - borderless
var window_size_index: int # 5 - 16:9 1080p
var render_scale: float # 1.0 - 1.0x

## Audio
var master: float
var music: float
var sfx: float
var dialogue: float

## General
var language_index: int # english (1 - estonian)

var indoors_mouse_sensitivity_x: float
var indoors_mouse_sensitivity_y: float

var outdoor_mouse_sensitivity: float
var outdoor_rotation_sensitivity: float

## Gameplay
var intro_seen: bool = false

func _ready():
	await ConfigFileHandler.ready
	framerate_index = ConfigFileHandler.load_video_setting("framerate")
	vsync_index = ConfigFileHandler.load_video_setting("vsync")
	window_mode_index = ConfigFileHandler.load_video_setting("window_mode")
	window_size_index = ConfigFileHandler.load_video_setting("window_size")
	render_scale = ConfigFileHandler.load_video_setting("3d_render_scale")
	
	master = ConfigFileHandler.load_audio_setting("master")
	music = ConfigFileHandler.load_audio_setting("music")
	sfx = ConfigFileHandler.load_audio_setting("sfx")
	dialogue = ConfigFileHandler.load_audio_setting("dialogue")
	
	language_index = ConfigFileHandler.load_general_setting("language")
	indoors_mouse_sensitivity_x = ConfigFileHandler.load_general_setting("indoors_mouse_sensitivity_x")
	indoors_mouse_sensitivity_y = ConfigFileHandler.load_general_setting("indoors_mouse_sensitivity_y")
	outdoor_mouse_sensitivity = ConfigFileHandler.load_general_setting("outdoor_mouse_sensitivity")
	outdoor_rotation_sensitivity = ConfigFileHandler.load_general_setting("outdoor_rotation_sensitivity")
	print("Settings have been applied to SettingsGlobal")
