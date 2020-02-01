extends KinematicBody2D

export(int, "Player 1", "Player 2") var controller
export var SPEED : int = 10000
export var CLIMB_SPEED : int = 10000
export var GRAVITY : int = 1000
var velocity = Vector2();
var player = "p1_"
onready var Swoosh = preload("res://Swoosh.tscn")
onready var CarryHammer = preload("res://CarryHammer.tscn")
onready var Hammer = preload("res://Hammer.tscn")

onready var Char1 = preload("res://resources/char1.png")
onready var Char2 = preload("res://resources/char2.png")

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

var on_ladder : bool = false

func _ready():
	if controller == 0:
		player = "p1_"
		$PlayerSprite.texture = Char1
	else:
		player = "p2_"
		$PlayerSprite.texture = Char2
	$PlayerSprite.position.y = -13
	$PlayerSprite.scale = Vector2(0.092, 0.092);

func instatiate_swoosh():
	var s = Swoosh.instance()
	s.scale.x = facing * 1.5
	s.scale.y = 0.75
	s.position.x = s.position.x + 20 * facing
	add_child(s)
	pass

func handle_swoosh_collision(area : Area2D):
	area.get_owner().kick(self)

func carry_hammer():
	item = ITEM.HAMMER
	hammer = CarryHammer.instance()
	$Carry.add_child(hammer)

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
		($UseItemLeft as RayCast2D).get_collider().owner.fix()
func chuck_hammer():
	item = null
	$Carry.remove_child(hammer)
	hammer = null
	var hammer_phys = Hammer.instance()
	hammer_phys.position = Vector2(facing * 64 + position.x, position.y)
	hammer_phys.apply_central_impulse(Vector2(facing * 500, -500))
	self.get_parent().add_child(hammer_phys)

func chuck_hose():
	pass

func set_carry_point():
	if facing == -1:
		$Carry.position = Vector2(-35, $Carry.position.y)
		if item == ITEM.HAMMER and hammer:
			hammer.rotation = 18
	else:
		$Carry.position = Vector2(35, $Carry.position.y)
		if item == ITEM.HAMMER and hammer:
			hammer.rotation = -18


func _physics_process(delta):
	get_input()
	handle_climbing()
	set_carry_point()
	if state == STATE.CLIMBING:
		velocity.x = 0
		self.position = Vector2(get_node("../Ladder").position.x, position.y)
	var _s = move_and_slide(velocity * delta)

func _on_LadderCollision_area_entered(_area):
	on_ladder = true

func _on_LadderCollision_area_exited(_area):
	on_ladder = false
	state = STATE.RUNNING
