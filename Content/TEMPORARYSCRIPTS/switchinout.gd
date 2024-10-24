extends Button

var reposition = Vector3(0, 20, 0).rotated(Vector3(1, 0, 0), 30) # (-10, 17.32051, 0)
var water_color = Vector4()# Color.html("0033ffff") # converts 0033ffff to Vector4
var child: Node

const LOADING = "res://Content/UI/loading.tscn"

@onready var camera = $"../../Camera/TopCamera"

func _process(delta):
	if child:
		child.get_node("Water").material_override.set("shader_parameter/out_color", water_color)

func _on_pressed():
	child = load(LOADING).instantiate()
	water_color = Color.html("0033ff00") # Make the water transparent
	child.position = reposition
	child.rotation.x = rad_to_deg(120)
	camera.add_child(child)
	
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "water_color:a", 1.0, 2)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(LOADING)
