extends Node2D


export var target_km : float = 10000;
var current_km : float = 0
export var max_travel_speed : float = 10
export var min_travel_speed : float = 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Submarine/SceneCamera/ProgressBar.value = current_km / target_km * 100
	if $Submarine/Engine.is_broken():
		return
	var speed = lerp(min_travel_speed, max_travel_speed, $Submarine/Engine.get_weight());
	current_km += speed * delta
	if current_km >= target_km:
		get_tree().change_scene("res://Victory.tscn")