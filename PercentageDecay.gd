extends Node2D

export var decay_rate : float = 2.5
export var fill_rate : float = 25
export var decay_tick : float = 1
var current_percentage = 100;


# Called when the node enters the scene tree for the first time.
func _process(delta):
	$Power.value = current_percentage

func action():
	current_percentage = clamp(current_percentage + fill_rate, 0, 100)

func _ready():
	($Timer as Timer).start(decay_tick)

func decay():
	current_percentage = clamp(current_percentage - decay_rate, 0, 100)
	
func set_percentage(perc):
	current_percentage = perc
	
func _on_Timer_timeout():
	decay()
