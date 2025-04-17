extends Node

@onready var animation_player = $AnimationPlayer

@onready var daylight_cycle = $"Daylight Cycle"

@onready var knight_spawner_s = $Knight_spawner_S
@onready var knight_spawner_s_2 = $Knight_spawner_S_2
@onready var time_sound_player = $"Daylight Cycle/Sound Player"

var times_of_day: Array[String] = ["morning", "day", "evening", "night"]
var current_time: String = "night"

var day: int = 1 ## globalize
var enemy_count: int = 0
var day_difficulty: Array[int] = []
var encouter_type: Array[int] = [] # 0 is knight attack, 1 is goblin attack, 2 is both attack, 3 is both fight, 4 is g attack k fight, 5 is k attack g fight, 6 is random attack

func _ready():
	if !SettingsGlobal.intro_seen:
		animation_player.play("intro")
		SettingsGlobal.intro_seen = true
	match day:
		1:
			day_difficulty = [5, 15, 24]
			encouter_type = [0, 0, 0]
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass
		7:
			pass
		8:
			pass
		9:
			pass
		10:
			pass
	await $"TEMPPauseMenuDetector/Camera switcher".game_ready
	
	advance_day()

#for enemyes 0 - tower
#            1 - other faction
#            2 - own leader

func enemy_death():
	enemy_count -= 1
	if enemy_count == 0:
		advance_day()


func advance_day():
	current_time = times_of_day.pop_front()
	times_of_day.append(current_time)
	
	#daylight_cycle.cycle_current_time()
	await get_tree().create_timer(3).timeout
	#mängi mingi tu-tu tu-tuuuuu pasun, et horde tuleb
	match current_time:
		"morning":
			generate_wave(day_difficulty[0], encouter_type[0])
			daylight_cycle.change_time_to("morning2")
			time_sound_player.play(["morning", "morning (2)"].pick_random())
		"day":
			generate_wave(day_difficulty[1], encouter_type[1])
			daylight_cycle.change_time_to("day")
			time_sound_player.play(["day", "day (2)"].pick_random())
		"evening":
			generate_wave(day_difficulty[2], encouter_type[2])
			daylight_cycle.change_time_to("evening")
			time_sound_player.play(["evening", "evening (2)"].pick_random())
		"night": event()


func generate_wave(dif: int, type: int):
	var spawner_amount: int
	match type:
		0:
			spawner_amount = randi_range(0, dif)
			if dif <= 10:
				spawn_knight_wave(dif, 0, 0)
			else:
				spawn_knight_wave(spawner_amount, dif - spawner_amount, 0)
		1: pass
		2: pass
		3: pass
		4: pass
		5: pass
		6: pass

func spawn_knight_wave(A: int, B: int, state):
	enemy_count = A + B
	
	knight_spawner_s.spawn(A, state)
	if A > 0:
		await get_tree().create_timer(randf()).timeout
		knight_spawner_s.horn_sound()
	
	knight_spawner_s_2.spawn(B, state)
	if B > 0:
		await get_tree().create_timer(randf()).timeout
		knight_spawner_s_2.horn_sound()

func event():
	daylight_cycle.change_time_to("night2")
	time_sound_player.play(["night", "night (2)"].pick_random())
	animation_player.play("demo win")

func DEATH():
	animation_player.play("death")
