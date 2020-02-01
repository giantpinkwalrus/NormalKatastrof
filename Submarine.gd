extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Ballasts_balance_change():
	var balance = $Ballasts.get_balance()
	$Ladder.set_balance(balance)
	#@TODO: animation
	$SceneCamera.rotation_degrees = 22 * -balance