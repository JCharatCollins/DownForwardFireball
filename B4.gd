extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func playState():
	var animPlayer = get_node("../../../RyuAnimationPlayer")
	animPlayer.play("B4")
	if animPlayer.current_animation_position <= 0.1:
		get_node("../../../").move_and_slide(Vector2(50, -200), Vector2.UP)
	elif animPlayer.current_animation_position >= 1.5:
		get_node("../../../").move_and_slide(Vector2(25, 300), Vector2.UP)
	else:
		get_node("../../../").move_and_slide(Vector2(100, 0), Vector2.UP)
