extends TabContainer

func _ready():
	get_tree().get_root().size_changed.connect(resize) # window size change signal
	resize()
	load_states_from_global()

func load_states_from_global():
	%OptionButtonFps.selected = SettingsGlobal.framerate_index
	fps(SettingsGlobal.framerate_index)
	%OptionButtonVsync.selected = SettingsGlobal.vsync_index
	vsync(SettingsGlobal.vsync_index)
	%OptionButtonWindow.selected = SettingsGlobal.window_mode_index
	window_mode(SettingsGlobal.window_mode_index)
	if SettingsGlobal.window_mode_index == 0:
		window_size(SettingsGlobal.window_size_index)
		%window_size.visible = true
	%OptionButtonSize.selected = SettingsGlobal.window_size_index
	%HSlider3drender.value = SettingsGlobal.render_scale
	resolution_scale(SettingsGlobal.render_scale)
	%"3DsensX".value = SettingsGlobal.indoors_mouse_sensitivity_x
	indoor_sens_x(SettingsGlobal.indoors_mouse_sensitivity_x)
	%"3DsensY".value = SettingsGlobal.indoors_mouse_sensitivity_y
	indoor_sens_y(SettingsGlobal.indoors_mouse_sensitivity_y)
	%"2Dmovesens".value = SettingsGlobal.outdoor_mouse_sensitivity
	outdoor_sens_move(SettingsGlobal.outdoor_mouse_sensitivity)
	%"2Drotsens".value = SettingsGlobal.outdoor_rotation_sensitivity
	outdoor_sens_rot(SettingsGlobal.outdoor_rotation_sensitivity)
	%"OptionButtonLang".selected = SettingsGlobal.language_index
	language_select(SettingsGlobal.language_index)

func resize():
	pass

func fps(index: int):
	SettingsGlobal.framerate_index = index
	ConfigFileHandler.save_video_setting("framerate", index)
	match index:
		0:
			Engine.max_fps = 30
		1:
			Engine.max_fps = 60
		2:
			Engine.max_fps = 120
		3:
			Engine.max_fps = 144
		4:
			Engine.max_fps = 165
		5:
			Engine.max_fps = 240
		6: # None
			Engine.max_fps = 0 # Sets it to unlimited

func vsync(index: int):
	SettingsGlobal.vsync_index = index
	ConfigFileHandler.save_video_setting("vsync", index)
	if index == 0: # Disabled (default)
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	elif index == 1: # Adaptive
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
	elif index == 2: # Enabled
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

func window_mode(index: int):
	SettingsGlobal.window_mode_index = index
	ConfigFileHandler.save_video_setting("window_mode", index)
	match index:
		0:
			get_tree().root.set_mode(Window.MODE_WINDOWED)
			%window_size.visible = true
			window_size(SettingsGlobal.window_size_index)
		1:
			get_tree().root.set_mode(Window.MODE_MAXIMIZED)
			%window_size.visible = false
		2:
			get_tree().root.set_mode(Window.MODE_EXCLUSIVE_FULLSCREEN)  # fullscreen
			%window_size.visible = false
		3:
			get_tree().root.set_mode(Window.MODE_FULLSCREEN)  # borderless
			%window_size.visible = false

func window_size(index: int):
	SettingsGlobal.window_size_index = index
	ConfigFileHandler.save_video_setting("window_size", index)
	match index:
		# 16:9
		1:
			get_viewport().size = Vector2i(640, 360)
		2:
			get_viewport().size = Vector2i(960, 540)
		3:
			get_viewport().size = Vector2i(1280, 720)
		4:
			get_viewport().size = Vector2i(1600, 900)
		5:
			get_viewport().size = Vector2i(1920, 1080)
		6:
			get_viewport().size = Vector2i(2560, 1440)
		7:
			get_viewport().size = Vector2i(3840, 2160)
		# 21:9
		9:
			get_viewport().size = Vector2i(840, 360)
		10:
			get_viewport().size = Vector2i(1260, 540)
		11:
			get_viewport().size = Vector2i(1680, 720)
		12:
			get_viewport().size = Vector2i(2100, 900)
		13:
			get_viewport().size = Vector2i(2520, 1080)
		14:
			get_viewport().size = Vector2i(3360, 1440)
		15:
			get_viewport().size = Vector2i(5040, 2160)
		# 4:3
		17:
			get_viewport().size = Vector2i(640, 480)
		18:
			get_viewport().size = Vector2i(960, 720)
		19:
			get_viewport().size = Vector2i(1280, 960)
		20:
			get_viewport().size = Vector2i(1600, 1200)
		21:
			get_viewport().size = Vector2i(1920, 1440)

func resolution_scale(value: float):
	SettingsGlobal.render_scale = value
	ConfigFileHandler.save_video_setting("3d_render_scale", value)
	get_viewport().scaling_3d_scale = value
	%scale.text = str(value).pad_decimals(1) + "x"

func indoor_sens_x(value: float):
	SettingsGlobal.indoors_mouse_sensitivity_x = value
	ConfigFileHandler.save_general_setting("indoors_mouse_sensitivity_x", value)
	%"3DsensXlabel".text = str(value).pad_decimals(1)

func indoor_sens_y(value: float):
	SettingsGlobal.indoors_mouse_sensitivity_y = value
	ConfigFileHandler.save_general_setting("indoors_mouse_sensitivity_y", value)
	%"3DsensYlabel".text = str(value).pad_decimals(1)

func outdoor_sens_move(value: float):
	SettingsGlobal.outdoor_mouse_sensitivity = value
	ConfigFileHandler.save_general_setting("outdoor_mouse_sensitivity", value)
	%"2Dmovelabel".text = str(value).pad_decimals(1)

func outdoor_sens_rot(value: float):
	SettingsGlobal.outdoor_rotation_sensitivity = value
	ConfigFileHandler.save_general_setting("outdoor_rotation_sensitivity", value)
	%"2Drotlabel".text = str(value).pad_decimals(1)

func language_select(index: int):
	SettingsGlobal.language_index = index
	ConfigFileHandler.save_general_setting("language", index)
	match index:
		0: TranslationServer.set_locale("en")
		1: TranslationServer.set_locale("et")
