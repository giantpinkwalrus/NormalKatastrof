extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal balance_change
signal left_ballast_broken
signal right_ballast_broken
signal shake

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

func action(side : Sprite, _player):
	
	if(side.is_broken()):
		return
	if side.name == "LeftBallast":
		$LeftBallast/LeftBalance.higher()
		$RightBallast/RightBalance.lower()
		$Shaker_Left.play()
	else:
		$LeftBallast/LeftBalance.lower()
		$RightBallast/RightBalance.higher()
		$Shaker_Right.play()
	emit_signal("balance_change")


func _on_LeftBallast_part_broken():
	emit_signal("left_ballast_broken")

func _on_RightBallast_part_broken():
	emit_signal("right_ballast_broken")


func _on_LeftBallast_shake():
	emit_signal("shake")

func _on_RightBallast_shake():
	emit_signal("shake")
