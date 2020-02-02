extends Node2D

signal destroy
signal shake

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action(_term, player):
	$Shaker.play()
	if !is_broken():
		emit_signal("destroy")
	else:
		pass

func get_weight():
	return $PercentageDecay.current_percentage / 100

func is_broken():
	return $Terminal.is_broken()
	
func _process(delta):
	if is_broken():
		$Sprite.visible = false
	else:
		$Sprite.visible = true

func _on_Terminal_part_broken():
	pass


func _on_Terminal_shake():
	emit_signal("shake")
