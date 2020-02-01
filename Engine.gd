extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action():
	$PercentageDecay.action()

func get_weight():
	return $PercentageDecay.current_percentage / 100

func is_broken():
	return $Terminal.is_broken()
	
func _process(delta):
	if $Terminal.is_broken():
		$PercentageDecay.set_percentage(0)
