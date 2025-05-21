extends Node

@onready var torn = $torn
@onready var spell_deploy_bar = $"Spell deploy bar"

@onready var animation_player = $AnimationPlayer

@onready var daylight_cycle = $"Daylight Cycle"

@onready var knight_spawner_s = $Knight_spawner_S
@onready var knight_spawner_l = $knight_spawner_L

@onready var knight_spawner_s_2 = $Knight_spawner_S_2
@onready var knight_spawner_l_2 = $knight_spawner_L_2

@onready var goblin_spawner_s = $goblin_spawner_S

@onready var goblin_spawner_s_2 = $goblin_spawner_S2

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
	set_difficulty()
	await $"Camera switcher".game_ready
	await get_tree().create_timer(2).timeout
	advance_day()

#for enemys 0 - tower
#            1 - other faction
#            2 - own leader

func set_difficulty():
	match day:
		1:
			day_difficulty = [5, 10, 18]
			encouter_type = [0, 0, 0]
		2:
			day_difficulty = [12, 8, 14]
			encouter_type = [1, randi_range(0, 1), 1]
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

func enemy_death():
	enemy_count -= 1
	if enemy_count == 0:
		advance_day()


func advance_day():
	current_time = times_of_day.pop_front()
	times_of_day.append(current_time)
	
	match current_time:
		"morning":
			daylight_cycle.change_time_to("morning2")
			time_sound_player.play(["morning", "morning (2)"].pick_random())
			
			await get_tree().create_timer(3).timeout
			generate_wave(day_difficulty[0], encouter_type[0])
		"day":
			daylight_cycle.change_time_to("day")
			time_sound_player.play(["day", "day (2)"].pick_random())
			
			await get_tree().create_timer(3).timeout
			generate_wave(day_difficulty[1], encouter_type[1])
		"evening":
			daylight_cycle.change_time_to("evening")
			time_sound_player.play(["evening", "evening (2)"].pick_random())
			
			await get_tree().create_timer(3).timeout
			generate_wave(day_difficulty[2], encouter_type[2])
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
		1: 
			spawner_amount = randi_range(0, dif)
			if dif <= 10:
				spawn_goblin_wave(dif, 0, 0)
			else:
				spawn_goblin_wave(spawner_amount, dif - spawner_amount, 0)
		2: pass
		3: pass
		4: pass
		5: pass
		6: pass

func spawn_knight_wave(A: int, B: int, state):
	var spawner_amount: int
	enemy_count = A + B
	
	spawner_amount = randi_range(0, A)
	knight_spawner_s.spawn(A - spawner_amount, state)
	knight_spawner_l.spawn(spawner_amount, state)
	
	spawner_amount = randi_range(0, B)
	knight_spawner_s_2.spawn(B - spawner_amount, state)
	knight_spawner_l_2.spawn(spawner_amount, state)
	
	if A > 0:
		knight_spawner_s.horn_sound()
	if B > 0:
		knight_spawner_s_2.horn_sound()


func spawn_goblin_wave(A: int, B: int, state):
	#var spawner_amount: int
	enemy_count = A + B
	
	#spawner_amount = randi_range(0, A)
	goblin_spawner_s.spawn(A, state)
	#.spawn(spawner_amount, state)
	
	#spawner_amount = randi_range(0, B)
	goblin_spawner_s_2.spawn(B, state)
	#.spawn(spawner_amount, state)
	
	if A > 0:
		knight_spawner_s.horn_sound()
	if B > 0:
		knight_spawner_s_2.horn_sound()


func event():
	daylight_cycle.change_time_to("night2")
	time_sound_player.play(["night", "night (2)"].pick_random())
	if day == 2: animation_player.play("demo win")
	else: 
		day += 1
		set_difficulty()
		torn.renew()
		spell_deploy_bar.mana = spell_deploy_bar.max_mana
		advance_day()

func DEATH():
	animation_player.play("death")
