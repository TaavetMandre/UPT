extends Button

## Scene that appears when the mouse hovers over a button, the scene must have a .self_destruct() method
@export var particles: PackedScene
@export var delay: float

@onready var current_hover_node: Node

func _ready():
	position.x += 1000 # Moves the button offscreen along the sidebar, x axis is 15 degrees off from the y axis
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:x", position.x - 1000, 0.5).set_delay(delay)

func _on_mouse_entered():
	var node = particles.instantiate()
	add_child(node)
	current_hover_node = node

func _on_mouse_exited():
	current_hover_node.self_destruct()

func move_up():
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", position.x - 1000, 0.5).set_delay(delay)

func disable_button_controls():
	mouse_filter = Control.MOUSE_FILTER_IGNORE # Disables button clicking
	disabled = true # Also disables it

func enable_button_controls():
	mouse_filter = Control.MOUSE_FILTER_STOP # Enables button clicking
	disabled = false # Also enables it

func quit_buttons(final_position):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position:y", final_position, 0.5)
