extends Node2D

var damage = 0
export var max_fire_chance = 0.5
export var min_fire_chance = 0.95


func _ready():
	randomize()

func spawn_fire():
	print("fire!!")

func _on_Ballasts_balance_change():
	var balance = $Ballasts.get_balance()
	$Ladder.set_balance(balance)
	#@TODO: animation
	$SceneCamera.rotation_degrees = 22 * -balance


func _on_FireTimer_timeout():
	var f = randf()
	print(lerp(min_fire_chance, max_fire_chance, damage))
	if(f > lerp(min_fire_chance, max_fire_chance, damage)):
		spawn_fire()
