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
	get_node("../../RyuAnimationPlayer").play("WalkBackward")
	get_node("../../").move_and_slide(Vector2(-100, get_parent().gravity), Vector2.UP)
