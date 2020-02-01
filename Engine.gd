extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal engine_broken

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action(_n, _p):
	$PercentageDecay.action()

func get_weight():
	return $PercentageDecay.current_percentage / 100

func is_broken():
	return $Terminal.is_broken()
	
func _process(_delta):
	if $Terminal.is_broken():
		$PercentageDecay.set_percentage(0)


func _on_Terminal_part_broken():
	emit_signal("engine_broken")
	pass # Replace with function body.
