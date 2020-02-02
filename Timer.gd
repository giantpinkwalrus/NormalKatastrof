extends Timer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	var rand = randi() % 7
	var sound = get_node("AudioStreamPlayer2D" + String(rand))
	(sound as AudioStreamPlayer2D).pitch_scale = rand_range(0.95, 1.05)
	sound.play()
