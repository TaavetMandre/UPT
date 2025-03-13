extends HSlider

@export var bus_name: String
@onready var label = $"../Label"

var bus_index: int
var bus_name_global: String

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# setting bus name global for saving and loading
	match bus_index:
		0: bus_name_global = "Master"
		1: bus_name_global = "Music"
		2: bus_name_global = "SFX"
		3: bus_name_global = "Dialogue"
	
	value_changed.connect(_on_value_changed)
	
	value = ConfigFileHandler.load_audio_setting(bus_name_global)
	if label:
		var value_percentage = int(value / max_value * 100)
		if value_percentage == 100:
			label.text = "%4d%%" % value_percentage
		elif 10 <= value_percentage:
			label.text = "%5d%%" % value_percentage  # eg " 62%"
		else:
			label.text = "%6d%%" % value_percentage  # eg "  5%"

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
	ConfigFileHandler.save_audio_setting(bus_name_global, value)
	if label:
		var value_percentage = int(value / max_value * 100)
		if value_percentage == 100:
			label.text = "%4d%%" % value_percentage
		elif 10 <= value_percentage:
			label.text = "%5d%%" % value_percentage
		else:
			label.text = "%6d%%" % value_percentage
