extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func action(side : Sprite):
	if(side.is_broken()):
		return
	if side.name == "LeftBallast":
		$LeftBallast/LeftBalance.higher()
		$RightBallast/RightBalance.lower()
	else:
		$LeftBallast/LeftBalance.lower()
		$RightBallast/RightBalance.higher()
			