extends CharacterBody3D
@export_range(0.1, 10.0) var nodrift: float = 1.0
@onready var meh = $ruutel2_0
@onready var nav : NavigationAgent3D = $NavigationAgent3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var suun: bool = true


enum States{TOWER, ENEMY, ATTACK, FROG}
var current_state : States


func _ready():
	current_state = States.TOWER


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
		States.TOWER: nav.set_target_position(Vector3(0,0,0))
		States.ENEMY: pass
		States.ATTACK: pass
		States.FROG: pass
	
	var trajektoor = velocity + (nav.get_next_path_position() - global_position).normalized() * delta * nodrift * nav.max_speed
	nav.set_velocity(trajektoor)


func test_timer():
	suun = !suun


func velocity_computed(safe_velocity):
	if current_state != States.ATTACK: velocity = safe_velocity
	else: velocity = Vector3(0,0,0)
	move_and_slide()


func _on_attack_body_entered(body):
	pass # Replace with function body.


func _on_attack_body_exited(body):
	pass # Replace with function body.
