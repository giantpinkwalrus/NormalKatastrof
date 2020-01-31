extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int, "Player 1", "Player 2") var controller
export var SPEED : int = 10000
export var GRAVITY : int = 1000
var velocity = Vector2();
var player = ""

enum STATE {
	FALLING,
	CLIMBING,
	RUNNING,
	DEAD,
	ON_TERMINAL,
	IDLE
}

var item = null

func _init():
	if controller == 0:
		player = "p1_"
	else:
		player = "p2_"

func get_input():
	if Input.is_action_pressed(player + "left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed(player + "right"):
		velocity.x = SPEED
	else:
		velocity.x = 0
	velocity.y += GRAVITY

func _physics_process(delta):
	get_input()
	move_and_slide(velocity * delta)
