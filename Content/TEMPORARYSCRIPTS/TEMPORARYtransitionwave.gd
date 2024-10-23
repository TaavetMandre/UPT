extends ColorRect

var strength = 60

func _process(delta):
	material.set("shader_parameter/strength", strength)

func _on_button_pressed():
	strength = 0
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "strength", 50, 10)
