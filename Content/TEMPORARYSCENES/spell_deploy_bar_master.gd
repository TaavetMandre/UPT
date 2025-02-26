extends Control

@export var ground: Node # to tell the spell where to place the indicator
@export var camera: Node # to shoot the ray to the ground
@export var spells: Array[Node]

var indicator_position
var indicator
var spell_instance

func _ready():
	for spell in spells:
		spell.ground = ground
		spell.camera = camera
		spell.show_indicator.connect(show_indicator)
		spell.deploy_spell.connect(deploy_spell)
		spell.hide_indicator.connect(hide_indicator)
		spell.disable_camera_dragging.connect(disable_camera_control)

func show_indicator(spell_card):
	if camera:
		indicator_position = camera.shoot_ray().get("position", Vector3.ZERO)
	if spell_card.indicator_scene and camera and not indicator:
		indicator = spell_card.indicator_scene.instantiate()
		
		# set position
		if indicator_position != Vector3.ZERO:
			indicator.position = indicator_position
		else:
			indicator.visible = false # if the mouse isnt hovering on the ground it hides the indicator
		
		add_child(indicator)
	elif indicator:
		if indicator_position != Vector3.ZERO:
			indicator.visible = true
			indicator.position = indicator_position
		else:
			indicator.visible = false

func deploy_spell(spell_card):
	if spell_card.indicator_scene and camera and indicator and spell_card.spell_scene:
		if indicator.visible: # if there is no valid position do not cast the spell
			spell_instance = spell_card.spell_scene.instantiate()
			spell_instance.position = indicator_position
			add_child(spell_instance)
		indicator.visible = false

func hide_indicator(spell_card):
	if spell_card.indicator_scene and camera and indicator and spell_card.spell_scene:
		indicator.visible = false

func disable_camera_control():
	camera.dragging = false
