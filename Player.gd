extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int, "Player 1", "Player 2") var controller
export var SPEED : int = 10000
export var CLIMB_SPEED : int = 10000
export var GRAVITY : int = 1000
var velocity = Vector2();
var player = ""

enum STATE {
	CLIMBING,
	RUNNING
}

var state = STATE.RUNNING
var item = null

var on_ladder : bool = false

func _init():
	if controller == 0:
		player = "p1_"
	else:
		player = "p2_"


func get_input():
	if state == STATE.RUNNING:
		#NORMAL
		if Input.is_action_pressed(player + "left"):
			velocity.x = -SPEED
		elif Input.is_action_pressed(player + "right"):
			velocity.x = SPEED
		else:
			velocity.x = 0
		if Input.is_action_pressed(player + "down") or Input.is_action_pressed(player + "up") and on_ladder:
			state = STATE.CLIMBING
			velocity.y = 0
		else:
			velocity.y += GRAVITY
	else:
		#LADDER
		if Input.is_action_pressed(player + "up"):
			velocity.y = -CLIMB_SPEED
		elif Input.is_action_pressed(player + "down"):
			velocity.y = CLIMB_SPEED
		else:
			velocity.y = 0
		if Input.is_action_pressed(player + "left") and $RayLeft.is_colliding() == false:
			state = STATE.RUNNING
		elif Input.is_action_pressed(player + "right") and !$RayRight.is_colliding():
			state = STATE.RUNNING

func handle_climbing():
	if state == STATE.CLIMBING:
		set_collision_mask_bit(0, 0)
	else:
		set_collision_mask_bit(0, 1)

func _physics_process(delta):
	get_input()
	handle_climbing()
	if state == STATE.CLIMBING:
		velocity.x = 0
		self.position = Vector2(get_node("../Ladder").position.x, position.y)
	move_and_slide(velocity * delta)

func _on_LadderCollision_area_entered(area):
	on_ladder = true

func _on_LadderCollision_area_exited(area):
	on_ladder = false
	state = STATE.RUNNING
