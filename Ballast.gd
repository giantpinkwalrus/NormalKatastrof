extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal balance_change

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_balance():
	if $LeftBallast/LeftBalance.current_level == $RightBallast/RightBalance.current_level:
		return 0
	if $LeftBallast/LeftBalance.current_level > $RightBallast/RightBalance.current_level:
		return -1
	else:
		return 1

func action(side : Sprite):
	if(side.is_broken()):
		return
	if side.name == "LeftBallast":
		$LeftBallast/LeftBalance.higher()
		$RightBallast/RightBalance.lower()
	else:
		$LeftBallast/LeftBalance.lower()
		$RightBallast/RightBalance.higher()
	emit_signal("balance_change")
