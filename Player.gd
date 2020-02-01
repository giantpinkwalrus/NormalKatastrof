extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int, "Player 1", "Player 2") var controller
export var SPEED : int = 10000
export var CLIMB_SPEED : int = 10000
export var GRAVITY : int = 1000
var velocity = Vector2();
var player = "p1_"
onready var Swoosh = preload("res://Swoosh.tscn")

enum STATE {
	CLIMBING,
	RUNNING
}

enum DIR {
	LEFT = -1,
	RIGHT = 1
}

var state = STATE.RUNNING
var facing = DIR.LEFT;
var item = null

var on_ladder : bool = false

func _init():
	if controller == 0:
		player = "p1_"
	else:
		player = "p2_"

func instatiate_swoosh():
	var s = Swoosh.instance()
	s.scale.x = facing * 1.5
	s.scale.y = 0.75
	s.position.x = s.position.x + 20 * facing
	add_child(s)
	pass

func handle_swoosh_collision(area : Area2D):
	area.get_owner().kick()

func get_input():
	if state == STATE.RUNNING:
		#NORMAL
		if Input.is_action_pressed(player + "left"):
			velocity.x = -SPEED
			facing = DIR.LEFT
		elif Input.is_action_pressed(player + "right"):
			velocity.x = SPEED
			facing = DIR.RIGHT
		else:
			velocity.x = 0
		if Input.is_action_pressed(player + "down") or Input.is_action_pressed(player + "up") and on_ladder:
			state = STATE.CLIMBING
			velocity.y = 0
		else:
			velocity.y += GRAVITY
		if Input.is_action_just_pressed(player + "action"):
			print("swoosh")
			instatiate_swoosh()
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
			facing = DIR.LEFT
		elif Input.is_action_pressed(player + "right") and !$RayRight.is_colliding():
			state = STATE.RUNNING
			facing = DIR.RIGHT

func handle_climbing():
	if state == STATE.CLIMBING:
		set_collision_mask_bit(4, 0)
	else:
		set_collision_mask_bit(4, 1)

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
