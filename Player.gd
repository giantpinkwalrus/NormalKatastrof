extends KinematicBody2D

export(int, "Player 1", "Player 2") var controller
export var SPEED : float = 45000
export var CLIMB_SPEED : float = 25000
export var GRAVITY : float = 1000

export var accel : float = 2500
export var drag : float = 500
var cur_speed : float = 0

var velocity = Vector2();
var player = "p1_"
onready var Swoosh = preload("res://Swoosh.tscn")
onready var CarryHammer = preload("res://CarryHammer.tscn")
onready var CarryHose = preload("res://CarryHose.tscn")
onready var Hammer = preload("res://Hammer.tscn")

signal fire_out(fire)
signal plug_leak(leak)

enum STATE {
	CLIMBING,
	RUNNING
}

enum DIR {
	LEFT = -1,
	RIGHT = 1
}

enum ITEM {
	HAMMER,
	HOSE
}

var state = STATE.RUNNING
var facing = DIR.LEFT;
var item = null
var hammer = null
var hose = null

var on_ladder : bool = false

func _ready():
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
	if area.is_in_group("leak"):
		emit_signal("plug_leak", area.owner)
		return
	area.get_owner().kick(self)

func carry_hammer():
	if item == null:
		item = ITEM.HAMMER
		hammer = CarryHammer.instance()
		$Carry.add_child(hammer)

func carry_hose():
	if item == null:
		item = ITEM.HOSE
		hose = CarryHose.instance()
		$Carry.add_child(hose)

func get_input():
	$PlayerSprite.play(player + "run")
	if state == STATE.RUNNING:
		#NORMAL
		if Input.is_action_pressed(player + "left"):
			velocity.x = -SPEED
			cur_speed = clamp(cur_speed - accel, -SPEED, SPEED);
			facing = DIR.LEFT
		elif Input.is_action_pressed(player + "right"):
			velocity.x = SPEED
			cur_speed = clamp(cur_speed + accel, -SPEED, SPEED);
			facing = DIR.RIGHT
		else:
			cur_speed = cur_speed - drag * sign(cur_speed)
			$PlayerSprite.play(player + "idle")
		if Input.is_action_pressed(player + "down") and on_ladder or Input.is_action_pressed(player + "up") and on_ladder:
			state = STATE.CLIMBING
			velocity.y = 0
		else:
			velocity.y += GRAVITY
		if Input.is_action_just_pressed(player + "action"):
			if item == null:
				instatiate_swoosh()
			elif item == ITEM.HAMMER:
				handle_hammer_swing()
			elif item == ITEM.HOSE:
				chuck_hose()
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

func handle_hammer_swing():
	if facing == DIR.LEFT and !$UseItemLeft.is_colliding():
		chuck_hammer()
	if facing == DIR.RIGHT and !$UseItemRight.is_colliding():
		chuck_hammer()
	if facing == DIR.LEFT and $UseItemLeft.is_colliding():
		($UseItemLeft as RayCast2D).get_collider().owner.fix()
	if facing == DIR.RIGHT and $UseItemRight.is_colliding():
		($UseItemRight as RayCast2D).get_collider().owner.fix()
func handle_hose():
	if facing == DIR.LEFT and $HoseLeft.is_colliding():
		emit_signal("fire_out", $HoseLeft.get_collider().owner)
	if facing == DIR.RIGHT and $HoseRight.is_colliding():
		emit_signal("fire_out", $HoseRight.get_collider().owner)

func chuck_hammer():
	item = null
	$Carry.remove_child(hammer)
	hammer = null
	var hammer_phys = Hammer.instance()
	hammer_phys.position = Vector2(facing * 64 + position.x, position.y)
	hammer_phys.apply_central_impulse(Vector2(facing * 500, -500))
	self.get_parent().add_child(hammer_phys)

func chuck_hose():
	item = null
	$Carry.remove_child(hose)
	hose = null
	get_node("../H20").return_hose()

func set_carry_point():
	if facing == -1:
		$Carry.position = Vector2(-35, $Carry.position.y)
		if item == ITEM.HAMMER and hammer:
			hammer.rotation = 18
		if item == ITEM.HOSE and hose:
			hose.flip_v = true
	else:
		$Carry.position = Vector2(35, $Carry.position.y)
		if item == ITEM.HAMMER and hammer:
			hammer.rotation = -18
		if item == ITEM.HOSE and hose:
			hose.flip_v = false

func _physics_process(delta):
	get_input()
	handle_climbing()
	set_carry_point()
	if state == STATE.CLIMBING:
		velocity.x = 0
		cur_speed = 0
		self.position = Vector2(get_node("../Ladder").position.x, position.y)
	var move = Vector2(cur_speed * delta, velocity.y * delta)
	var _s = move_and_slide(move)
	if item == ITEM.HOSE and hose:
		handle_hose()

func _on_LadderCollision_area_entered(_area):
	on_ladder = true

func _on_LadderCollision_area_exited(_area):
	on_ladder = false
	state = STATE.RUNNING
