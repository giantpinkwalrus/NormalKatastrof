extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_pressed():
	var _foo = get_tree().change_scene("res://Game.tscn")


func _on_How_to_play_pressed():
	($PopupPanel as PopupPanel).popup_centered(Vector2(500, 300))


func _on_Close_pressed():
	($PopupPanel as PopupPanel).hide()
