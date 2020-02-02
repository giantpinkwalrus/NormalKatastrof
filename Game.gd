extends Node2D


export var target_km : float = 5000;
var current_km : float = 0
export var max_travel_speed : float = 10
export var min_travel_speed : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Submarine/SceneCamera/ProgressBar.value = current_km / target_km * 100
	$Submarine/SceneCamera/Progress/Sub.position.x = lerp(-465.268, 506, current_km / target_km)
	if $Submarine/Engine.is_broken():
		return
	var speed = lerp(min_travel_speed, max_travel_speed, $Submarine/Engine.get_weight());
	var change = speed * delta
	current_km += change
	if $Boat.alive:
		$Boat.change_distance(change)
	if current_km >= target_km:
		var _foo = get_tree().change_scene("res://Victory.tscn")

func _on_Submarine_lose():
	var _foo = get_tree().change_scene("res://Lose.tscn")


func _on_BoatTimer_timeout():
	if $Boat.alive:
		return
	else:
		$Boat.spawn_boat()


func _on_Torpedo_destroy():
	$Boat.kill_boat()
