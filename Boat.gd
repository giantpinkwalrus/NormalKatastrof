extends Node2D


var alive = false
export var default_distance : float = 150
var current_distance : float

onready var Explosion = preload("res://Explosion.tscn")

var max_size = 0.192
var min_size = 0

func spawn_boat():
	alive = true
	current_distance = default_distance
	$Graphic.visible = true

func kill_boat():
	alive = false
	$Graphic.visible = false
	var expl = Explosion.instance()
	expl.position = $Graphic.position
	expl.get_node("Sprite/AnimationPlayer").play("Explosion")
	self.add_child(expl)
	current_distance = 1000

func change_distance(amount):
	current_distance = clamp(current_distance - amount, 0, 150)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Graphic.visible = false
	pass # Replace with function body.

func get_weight():
	return (default_distance - current_distance) / default_distance

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !alive:
		pass
	else:
		var scl = lerp(min_size, max_size, get_weight())
		$Graphic.scale = Vector2(scl, scl)
