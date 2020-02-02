extends Node2D

var damage = 0
export var max_fire_chance = 0.5
export var min_fire_chance = 0.95
var fires_top = [0, 0, 0, 0, 0, 0, 0]
var fires_bot = [0, 0, 0, 0, 0, 0, 0]
var fires = [fires_top, fires_bot];
onready var Fire = preload("res://Fire.tscn")

func _ready():
	randomize()
	
func spawn_fire():
	var free_spots = get_free_fire()
	var spot = free_spots[randi() % free_spots.size()];
	fires[spot.y][spot.x] = 1
	var fire = Fire.instance()
	$Fires.get_node(String(spot.x) + "_" + String(spot.y)).add_child(fire)

func put_out_fire(spot):
	fires[spot.y][spot.x] = 0

func get_free_fire():
	var free = Array()
	for x in range(fires_top.size()):
		if fires_top[x] == 0:
			free.append(Vector2(x, 0))
	for x in range(fires_bot.size()):
		if fires_bot[x] == 0:
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
