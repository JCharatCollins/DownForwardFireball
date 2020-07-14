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
	get_node("../../../RyuAnimationPlayer").play("B4")
	get_parent().jumpPower.y += get_parent().get_parent().gravity
	get_node("../../../").move_and_slide(get_parent().jumpPower + Vector2(200, 70), Vector2.UP)
