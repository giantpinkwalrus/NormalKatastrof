extends Node2D

export(int, "Left", "Right") var side
enum LEVEL {
	BOTTOM,
	MIDDLE,
	TOP
}

var current_level = 1;

func _process(_delta):
	$Label.text = String(current_level)

func lower():
	current_level = clamp(current_level - 1, 0, 2)
	
func higher():
	current_level = clamp(current_level + 1, 0, 2)
