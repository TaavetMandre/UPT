extends CharacterBody3D

@export_range(0, 2) var start_state: int = 0 ##Default state with which the npc starts out with:[br]0 - chase tower[br]1 - chase enemies[br]2 - chase leader
@export var HP: int = 3
@export var damage: int = 1
@export var master: Node
@export_range(0.1, 10.0) var nodrift: float = 1.0
@onready var meh = $ruutel2_0
@onready var nav : NavigationAgent3D = $NavigationAgent3D
@onready var timer = $Timer
@onready var attack = $attack
@onready var anim = $AnimationPlayer

@onready var attack_sound = $Attack
@export var ATTACK_SOUNDS: Array[AudioStream]
@onready var hurt_sound = $Hurt
@onready var damage_particle := preload("res://Content/Other/damage particles.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum States{TOWER, ENEMY, ATTACK, FOLLOW, FROG, FLEE}
var current_state : States
var default_state : States

func _ready():
	match start_state:
		0: default_state = States.TOWER
		1: default_state = States.ENEMY
		2: default_state = States.FOLLOW
	current_state = default_state


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	if is_on_floor():
		if velocity :
			var T = global_transform.looking_at(self.global_transform.origin + velocity.normalized(), Vector3(0, 1, 0)) #internetist varastatud lahendus mis on sobivaks muudetud, mulle isegi suuremosalt arusaadav
			global_transform.basis.y=lerp(global_transform.basis.y, T.basis.y, 0.2)
			global_transform.basis.x=lerp(global_transform.basis.x, T.basis.x, 0.2)
			global_transform.basis.z=lerp(global_transform.basis.z, T.basis.z, 0.2)
	
	match current_state:
		States.TOWER:
			nav.set_target_position(Vector3(0,0,0))
		States.ENEMY: pass
		States.ATTACK:
			if attack.has_overlapping_bodies():# and anim.current_animation != "hit":
				anim.play("hit")
			else: current_state = default_state
		States.FROG: pass
	
	var trajektoor = velocity + (nav.get_next_path_position() - global_position).normalized() * delta * nodrift * nav.max_speed
	nav.set_velocity(trajektoor)


func test_timer():
	self.queue_free()


func velocity_computed(safe_velocity):
	if current_state != States.ATTACK: velocity = safe_velocity
	else: velocity = Vector3(0,0,0)
	move_and_slide()


func _on_attack_body_entered(body):
	current_state = States.ATTACK
	#wait some time


func damaged(dam: int):
	HP -= dam
	
	hurt_sound.pitch_scale += randf_range(-0.05, 0.05)
	hurt_sound.play()
	hurt_sound.pitch_scale = 1
	
	var particle = damage_particle.instantiate()
	particle.damage_amount = dam
	add_child(particle)
	
	#animatsioon/indikaator vahel
	if HP <= 0 and timer.is_stopped():
		master.enemy_death()
		#animatsioon/indikaator vahel
		#maailmale (globalile arvatavasti) teade, et surid
		timer.start()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "hit":
		for i in attack.get_overlapping_bodies():
			i.damaged(damage)
		
		var attack_sound_file = ATTACK_SOUNDS.pick_random()
		attack_sound.stream = attack_sound_file
		attack_sound.pitch_scale += randf_range(-0.05, 0.05)
		attack_sound.play()
		attack_sound.pitch_scale = 1
