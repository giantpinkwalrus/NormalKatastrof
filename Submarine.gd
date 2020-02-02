extends Node2D

var damage = 0
export var max_fire_chance = 0.35
export var min_fire_chance = 0.85
var fires_top = [0, 0, 0, 0, 0, 0, 0]
var fires_bot = [0, 0, 0, 0, 0, 0, 0]
var fires = [fires_top, fires_bot];

export var max_leak_chance = 0.35
export var min_leak_chance = 0.85
var leaks_top = [0, 0, 0, 0, 0, 0, 0]
var leaks_bot = [0, 0, 0, 0, 0, 0, 0]
var leaks = [leaks_top, leaks_bot];


onready var Fire = preload("res://Fire.tscn")
onready var Leak = preload("res://Leak.tscn")

func _ready():
	randomize()

func spawn_fire():
	var free_spots = get_free_fire()
	if free_spots.size() == 0:
		return
	var spot = free_spots[randi() % free_spots.size()];
	fires[spot.y][spot.x] = 1
	var fire = Fire.instance()
	$Fires.get_node(String(spot.x) + "_" + String(spot.y)).add_child(fire)

func spawn_leak():
	var free_spots : Array = get_free_leak()
	if free_spots.size() == 0:
		return
	var spot = free_spots[randi() % free_spots.size()];
	leaks[spot.y][spot.x] = 1
	var leak = Leak.instance()
	leak.get_node("Node2D/AnimationPlayer").play("Drop")
	$Leaks.get_node(String(spot.x) + "_" + String(spot.y)).add_child(leak)

func put_out_fire(spot):
	fires[spot.y][spot.x] = 0

func plug_leak(spot):
	leaks[spot.y][spot.x] = 0

func get_free_fire():
	var free = Array()
	for x in range(fires_top.size()):
		if fires_top[x] == 0:
			free.append(Vector2(x, 0))
	for x in range(fires_bot.size()):
		if fires_bot[x] == 0:
			free.append(Vector2(x, 1))
	return free
	
func get_free_leak():
	var free = Array()
	for x in range(leaks_top.size()):
		if leaks_top[x] == 0:
			free.append(Vector2(x, 0))
	for x in range(leaks_bot.size()):
		if leaks_bot[x] == 0:
			free.append(Vector2(x, 1))
	return free

func _on_Ballasts_balance_change():
	var balance = $Ballasts.get_balance()
	$Ladder.set_balance(balance)
	#@TODO: animation
	$SceneCamera.rotation_degrees = 22 * -balance


func _on_FireTimer_timeout():
	var f = randf()
	if(f > lerp(min_fire_chance, max_fire_chance, damage)):
		spawn_fire()

func damage_ship(amount = 0.01):
	damage += amount

func _on_Ballasts_left_ballast_broken():
	damage_ship()

func _on_Ballasts_right_ballast_broken():
	damage_ship()

func _on_Engine_engine_broken():
	damage_ship()


func _on_Player2_fire_out(fire):
	var name = fire.get_parent().name
	var c = name.split("_")
	put_out_fire(Vector2(c[0], c[1]))
	fire.queue_free()

func _on_Player_fire_out(fire):
	var name = fire.get_parent().name
	var c = name.split("_")
	put_out_fire(Vector2(c[0], c[1]))
	fire.queue_free()


func _on_H20_h20_broken():
	damage_ship()


func _on_Player_plug_leak(leak):
	var name = leak.get_parent().name
	var c = name.split("_")
	put_out_fire(Vector2(c[0], c[1]))
	leak.queue_free()


func _on_Player2_plug_leak(leak):
	var name = leak.get_parent().name
	var c = name.split("_")
	put_out_fire(Vector2(c[0], c[1]))
	leak.queue_free()


func _on_LeakTimer_timeout():
	var f = randf()
	if(f > lerp(min_leak_chance, max_leak_chance, damage)):
		spawn_leak()
