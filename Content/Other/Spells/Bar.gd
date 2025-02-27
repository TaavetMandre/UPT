extends TextureRect

@export var move_amount = 150
@export var dismiss_area_size = 200
var bar_state = "raised"
@onready var raised_height = get_window().size.y - move_amount
@onready var lowered_height = get_window().size.y

## Nodes
@onready var card_show_area = %"Card Show Area"
@onready var dismiss_area = %DismissArea
@onready var label = %Label


func _ready():
	get_tree().get_root().size_changed.connect(resize) # window size change signal
	resize()

func resize():
	raised_height = get_window().size.y - move_amount
	lowered_height = get_window().size.y
	
	position.y = get_window().size.y - move_amount
	
	card_show_area.position.y = get_window().size.y - dismiss_area_size
	label.global_position.y = get_window().size.y - (dismiss_area_size / 2) - (label.size.y / 2) + (dismiss_area_size * 0.1)
	label.global_position.x = (get_window().size.x / 2) - (label.size.x / 2)
	
	get_tree().call_group("spellcards", "resize", dismiss_area_size)
	get_tree().call_group("spellcards", "set_new_zero_position_y", get_window().size.y - dismiss_area_size / 2)

func lower_bar():
	if bar_state == "raised":
		get_tree().call_group("spellcards", "flip_is_called")
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(self, "position:y", lowered_height, 0.5)
		bar_state = "lowered"
		
		tween.tween_property(dismiss_area, "modulate:a", 1, 0.5)
		
		get_tree().call_group("spellcards", "set_new_zero_position_y", get_window().size.y + dismiss_area_size / 2)

func raise_bar():
	if bar_state == "lowered":
		get_tree().call_group("spellcards", "flip_is_called")
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC).set_parallel(true)
		tween.tween_property(self, "position:y", raised_height, 0.5)
		bar_state = "raised"
		
		tween.tween_property(dismiss_area, "modulate:a", 0, 0.5)
		
		get_tree().call_group("spellcards", "set_new_zero_position_y", get_window().size.y - dismiss_area_size / 2)

