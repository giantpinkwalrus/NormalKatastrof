extends Node2D

signal h20_broken

var has_hose = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action(_term, player):
	if has_hose:
		if player.item == null:
			player.carry_hose()
			has_hose = false
			$HoseHolder.visible = false
			$PercentageDecay.disabled = false
	else:
		$PercentageDecay.action()

func return_hose():
	has_hose = true
	$HoseHolder.visible = true
	$PercentageDecay.disabled = true

func get_weight():
	return $PercentageDecay.current_percentage / 100

func is_broken():
	return $Terminal.is_broken()
	
func _process(_delta):
	if has_hose:
		$Terminal.kick_degradation = 0
	else:
		$Terminal.kick_degradation = 15
	if $Terminal.is_broken():
		$PercentageDecay.set_percentage(0)


func _on_Terminal_part_broken():
	emit_signal("h20_broken")
	pass # Replace with function body.
