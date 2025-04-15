extends Control

@export var ground: Node # to tell the spell where to place the indicator
@export var camera: Node # to shoot the ray to the ground
@export var spells: Array[Node]

var indicator_position: Vector3
var indicator_normal: Vector3
var spell_rotate_to_surface_normal: bool
var spell_card_rotation
var indicators = {}
var spell_instance

func _ready():
	for spell in spells:
		#spell_rotate_to_surface_normal = spell.rotate_to_surface_normal
		spell.ground = ground
		spell.camera = camera
		spell.show_indicator.connect(show_indicator)
		spell.deploy_spell.connect(deploy_spell)
		spell.hide_indicator.connect(hide_indicator)
		spell.disable_camera_dragging.connect(disable_camera_control)
		indicators[spell] = []

func show_indicator(spell_card):
	var indicator_list = indicators.get(spell_card)
	if camera:
		indicator_position = camera.shoot_ray().get("position", Vector3.ZERO)
		if spell_rotate_to_surface_normal:	indicator_normal = camera.shoot_ray().get("normal", Vector3.ZERO)
	if spell_card.indicator_scene and camera and not indicator_list:  # create the indicator
		var indicator = spell_card.indicator_scene.instantiate()
		
		# set the rotation to be the same as the spell's rotation
		spell_card_rotation = spell_card.spell_scene.instantiate().rotation
		indicator.rotation.y = spell_card_rotation.y + camera.rotation.y
		
		## rotate to surface normal (if the boolean is true)
		#print(indicator_normal)
		#if spell_rotate_to_surface_normal:
			#var indicator_quaternion = Quaternion(indicator.transform.basis)  # converts the current rotation to a quaternion
			#var normal_quaternion = Quaternion.from_euler(indicator_normal)
			#var result_quaternion = indicator_quaternion.slerp(normal_quaternion, 0.1)  # spherical lerp
			#indicator.transform.basis = Basis(result_quaternion)
		
		# set position
		if indicator_position != Vector3.ZERO:
			indicator.position = indicator_position
		else:
			indicator.visible = false # if the mouse isnt hovering on the ground it hides the indicator
		
		indicators[spell_card].append(indicator)
		indicators[spell_card].append(spell_card_rotation)
		add_child(indicator)
	elif indicator_list:
		spell_card_rotation = indicator_list[1]
		var indicator = indicator_list[0]
		
		## rotate to the surface normal
		#if spell_rotate_to_surface_normal:
			#var indicator_quaternion = Quaternion(indicator.transform.basis)  # converts the current rotation to a quaternion
			#var normal_quaternion = Quaternion.from_euler(indicator_normal.rotated(Vector3(0, 0, 1), 0))
			#var result_quaternion = indicator_quaternion.slerp(normal_quaternion, 0.1)  # spherical lerp
			#indicator.transform.basis = Basis(result_quaternion)
		
		# rotate to the camera
		indicator.rotation.y = spell_card_rotation.y + camera.rotation.y
		
		if indicator_position != Vector3.ZERO:
			indicator.visible = true
			indicator.position = indicator_position
		else:
			indicator.visible = false

func deploy_spell(spell_card):
	var indicator_list = indicators.get(spell_card)
	var indicator
	if indicator_list: indicator = indicator_list[0]
	if spell_card.indicator_scene and camera and indicator and spell_card.spell_scene:
		if indicator.visible: # if there is no valid position do not cast the spell
			spell_instance = spell_card.spell_scene.instantiate()
			spell_instance.position = indicator_position
			spell_instance.rotation.y = indicator.rotation.y
			add_child(spell_instance)
		indicator.visible = false

func hide_indicator(spell_card):
	var indicator_list = indicators.get(spell_card)
	var indicator
	if indicator_list: indicator = indicator_list[0]
	if spell_card.indicator_scene and camera and indicator and spell_card.spell_scene:
		indicator.visible = false

func disable_camera_control():
	if camera:
		camera.dragging = false
