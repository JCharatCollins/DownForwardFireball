extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const Fireball = preload("res://Fireball.tscn")
var projectiles

# Called when the node enters the scene tree for the first time.
func _ready():
	projectiles = get_node("../../../Projectiles")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func playState():
	var animPlayer = get_node("../../../RyuAnimationPlayer")
	animPlayer.play("B5")
	if animPlayer.current_animation_position >= 0.3 and projectiles.get_child_count() == 0:
		var fireball = Fireball.instance()
		fireball.init("Right", get_node("../../../").get_global_position()+Vector2(40,-10))
		projectiles.add_child(fireball)
		
