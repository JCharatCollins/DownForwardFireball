extends Node
export var jumpPower = Vector2(0, -200)
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
	get_node("../../RyuAnimationPlayer").play("NeutralJump")
	jumpPower.y += get_parent().gravity
	get_node("../../").move_and_slide(jumpPower, Vector2.UP)
