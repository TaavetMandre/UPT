extends CharacterBody3D
@export var speed: float = 300
@onready var meh = $ruutel2_0
@onready var nav : NavigationAgent3D = $NavigationAgent3D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var suun: bool = true

func _ready():
	#var tween = get_tree().create_tween().set_loops()
	#tween.tween_property(self, "rotation:y" , PI, 1).from_current()
	pass


func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	if is_on_floor():
		#var smoov = get_tree().create_tween().set_loops()
		#smoov.tween_property(self, "velocity:x", speed * delta, 1).from_current()
		#smoov.tween_property(self, "velocity:z", speed * delta, 1).from_current()
		#smoov.tween_property(self, "velocity:x", -speed * delta, 1).from_current()
		#smoov.tween_property(self, "velocity:z", -speed * delta, 1).from_current()
		#velocity.x = move_toward(velocity.x, 0, speed*delta/2)
		#velocity.z = move_toward(velocity.z, 0, speed*delta/2)
		pass
	
	
	match suun:
		true: nav.set_target_position(Vector3(50, 0 , 30))
		false: nav.set_target_position(Vector3(40, -1, -20))
	
	var koht = nav.get_next_path_position()
	var trajektoor = koht - global_position
	var norm_traj = trajektoor.normalized()
	velocity = norm_traj * speed * delta
	move_and_slide()


func test_timer():
	suun = !suun
