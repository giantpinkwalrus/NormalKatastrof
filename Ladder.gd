extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var slide_speed = 500
var balance = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_balance(new_balance):
	balance = new_balance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(Vector2(slide_speed * balance, 0))
	pass
