extends KinematicBody2D

var direction = Vector2(1, 0)
export var speed = Vector2(100, 0)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func init(playerDirection, playerPos):
	set_global_position(playerPos)
	if playerDirection == "Right":
		 direction.x = 1
	elif playerDirection == "Left":
		direction.x = -1
	

# Called when the node enters the scene tree for the first time.
func _ready():
	if direction.x == -1:
		get_node("FireballSprite").set_flip_h(false)
	elif direction.x == 1:
		get_node("FireballSprite").set_flip_h(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	self.move_and_slide(direction*speed)
	commit_seppuku()

func commit_seppuku():
	if abs(self.get_global_position().x) > 200:
		queue_free()
	
