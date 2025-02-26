extends TextureRect

@export var move_amount = 100
var bar_state = "raised"
@onready var raised_height = get_window().size.y - move_amount
@onready var lowered_height = get_window().size.y
@onready var card_show_area = %"Card Show Area"

func _ready():
	get_tree().get_root().size_changed.connect(resize) # window size change signal
	position.y = get_window().size.y - 100
	
	card_show_area.position.y = position.y - 120

func resize():
	raised_height = get_window().size.y - move_amount
	lowered_height = get_window().size.y
	position.y = get_window().size.y - 100
	
	card_show_area.position.y = position.y - 120

func lower_bar():
	if bar_state == "raised":
		get_tree().call_group("spellcards", "flip_is_called")
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position:y", lowered_height, 0.5)
		bar_state = "lowered"

func raise_bar():
	if bar_state == "lowered":
		get_tree().call_group("spellcards", "flip_is_called")
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "position:y", raised_height, 0.5)
		bar_state = "raised"

