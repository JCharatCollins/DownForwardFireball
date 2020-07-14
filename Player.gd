extends KinematicBody2D
enum HORIZONTAL_DIRECTIONS {LEFT, RIGHT, CENTER}
enum VERTICAL_DIRECTIONS {UP, CENTER}
enum DIRECTIONS {N, F, UF, U, UB, B}
var animPlayer
var stateStack = []
var stateNodePath
var animFinished
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	animPlayer = $AnimationPlayer
	stateStack.append("Idle")
	get_node("RyuSprite").set_flip_h(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Gets player input for the frame.
	var frameInput = inputResolve(directionalInputResolve(Input.is_action_pressed("Jump"), horizontalInputResolve(Input.is_action_pressed("Left"), Input.is_action_pressed("Right"))), Input.is_action_just_pressed("A"), Input.is_action_just_pressed("B"))
	#Changes states for the frame.
	changeState(stateStack, frameInput)
	#Runs code from the new states based on elements in stateStack.
	stateNodePath = "States/"
	for i in stateStack.size():
		stateNodePath += stateStack[i] + "/"
	get_node(stateNodePath).playState()
	print(stateStack)
	pass
	
#Handles SOCD.
func horizontalInputResolve(Left, Right):
	if Left and Right:
		return HORIZONTAL_DIRECTIONS.CENTER
	elif Left:
		return HORIZONTAL_DIRECTIONS.LEFT
	elif Right:
		return HORIZONTAL_DIRECTIONS.RIGHT
	else:
		return HORIZONTAL_DIRECTIONS.CENTER

#Resolves jump button as another directional key because I don't like jump buttons.
func directionalInputResolve(Button_Jump, hDir):
	var input = [Button_Jump, hDir]
	var directionalInputResolveDict = {
		[true, HORIZONTAL_DIRECTIONS.LEFT]: DIRECTIONS.UB,
		[true, HORIZONTAL_DIRECTIONS.RIGHT]: DIRECTIONS.UF,
		[true, HORIZONTAL_DIRECTIONS.CENTER]: DIRECTIONS.U,
		[false, HORIZONTAL_DIRECTIONS.LEFT]: DIRECTIONS.B,
		[false, HORIZONTAL_DIRECTIONS.RIGHT]: DIRECTIONS.F,
		[false, HORIZONTAL_DIRECTIONS.CENTER]: DIRECTIONS.N
	}
	return directionalInputResolveDict[input]

#resolves input and outputs it in readable format based on 2 buttons + jump button.
func inputResolve(direction, Button_A, Button_B):
	var output = []
	output.append(direction)
	if Button_A:
		output.append("A")
	if Button_B:
		output.append("B")
	return output

#Changes state each frame based on player input and the current state stack. References getStateMapTransition to get new states to append based on stateMaps
func changeState(stateStack, input):
	var topLevelState = stateStack[-1]
	var newStates = getStateMapTransition(topLevelState, input)
	stateStack.clear()
	for i in newStates.size():
		stateStack.append(newStates[i])
	pass

#Gets stateMapTransitions based on input. Helper function for changeState.
func getStateMapTransition(state, input):
	if state == "Idle":
		return Idle_Transitions(input)
	elif state == "WalkBackward":
		return WalkBackward_Transitions(input)
	elif state == "WalkForward":
		return WalkForward_Transitions(input)
	elif state == "NeutralJump":
		return NeutralJump_Transitions(input)
	elif state == "BackJump":
		return BackJump_Transitions(input)
	elif state == "ForwardJump":
		return ForwardJump_Transitions(input)
	elif state == "A5":
		return A5_Transitions(input)
	elif state == "B4":
		return B4_Transitions(input)
	elif state == "B5":
		return B5_Transitions(input)
	elif state == "NJA5":
		return NJA5_Transitions(input)
	elif state == "BJA5":
		return BJA5_Transitions(input)
	elif state == "FJA5":
		return FJA5_Transitions(input)
	elif state == "NJB4":
		return NJB4_Transitions(input)
	elif state == "BJB4":
		return BJB4_Transitions(input)
	elif state == "FJB4":
		return FJB4_Transitions(input)
	elif state == "B6":
		return B6_Transitions(input)

#--------------------------
#  STATE MAPS: BE CAREFUL
#--------------------------
#Basic grounded stateMap for repeated use.
var groundedStatesMap = {
	[DIRECTIONS.B]: ["WalkBackward"],
	[DIRECTIONS.N]: ["Idle"],
	[DIRECTIONS.F]: ["WalkForward"],
	[DIRECTIONS.U]: ["NeutralJump"],
	[DIRECTIONS.UB]: ["BackJump"],
	[DIRECTIONS.UF]: ["ForwardJump"],
	[DIRECTIONS.N, "A"]: ["Idle", "A5"],
	[DIRECTIONS.F, "A"]: ["Idle", "A5"],
	[DIRECTIONS.B, "A"]: ["Idle", "A5"],
	[DIRECTIONS.U, "A"]: ["Idle", "A5"],
	[DIRECTIONS.UB, "A"]: ["Idle", "A5"],
	[DIRECTIONS.UF, "A"]: ["Idle", "A5"],
	[DIRECTIONS.N, "B"]: ["Idle", "B5"],
	[DIRECTIONS.B, "B"]: ["NeutralJump", "B4"]
}
var neutralJumpingStatesMap = {
	[DIRECTIONS.B]: ["NeutralJump"],
	[DIRECTIONS.N]: ["NeutralJump"],
	[DIRECTIONS.F]: ["NeutralJump"],
	[DIRECTIONS.U]: ["NeutralJump"],
	[DIRECTIONS.UB]: ["NeutralJump"],
	[DIRECTIONS.UF]: ["NeutralJump"],
	[DIRECTIONS.N, "A"]: ["NeutralJump", "NJA5"],
	[DIRECTIONS.F, "A"]: ["NeutralJump", "NJA5"],
	[DIRECTIONS.B, "A"]: ["NeutralJump", "NJA5"],
	[DIRECTIONS.U, "A"]: ["NeutralJump", "NJA5"],
	[DIRECTIONS.UB, "A"]: ["NeutralJump", "NJA5"],
	[DIRECTIONS.UF, "A"]: ["NeutralJump", "NJA5"],
	[DIRECTIONS.B, "B"]: ["NeutralJump", "NJB4"],
	[DIRECTIONS.UB, "B"]: ["NeutralJump", "NJB4"],
}
var backJumpingStatesMap = {
	[DIRECTIONS.B]: ["BackJump"],
	[DIRECTIONS.N]: ["BackJump"],
	[DIRECTIONS.F]: ["BackJump"],
	[DIRECTIONS.U]: ["BackJump"],
	[DIRECTIONS.UB]: ["BackJump"],
	[DIRECTIONS.UF]: ["BackJump"],
	[DIRECTIONS.N, "A"]: ["BackJump", "BJA5"],
	[DIRECTIONS.F, "A"]: ["BackJump", "BJA5"],
	[DIRECTIONS.B, "A"]: ["BackJump", "BJA5"],
	[DIRECTIONS.U, "A"]: ["BackJump", "BJA5"],
	[DIRECTIONS.UB, "A"]: ["BackJump", "BJA5"],
	[DIRECTIONS.UF, "A"]: ["BackJump", "BJA5"],
	[DIRECTIONS.B, "B"]: ["BackJump", "BJB4"],
	[DIRECTIONS.UB, "B"]: ["BackJump", "BJB4"],
}
var forwardJumpingStatesMap = {
	[DIRECTIONS.B]: ["ForwardJump"],
	[DIRECTIONS.N]: ["ForwardJump"],
	[DIRECTIONS.F]: ["ForwardJump"],
	[DIRECTIONS.U]: ["ForwardJump"],
	[DIRECTIONS.UB]: ["ForwardJump"],
	[DIRECTIONS.UF]: ["ForwardJump"],
	[DIRECTIONS.N, "A"]: ["ForwardJump", "FJA5"],
	[DIRECTIONS.F, "A"]: ["ForwardJump", "FJA5"],
	[DIRECTIONS.B, "A"]: ["ForwardJump", "FJA5"],
	[DIRECTIONS.U, "A"]: ["ForwardJump", "FJA5"],
	[DIRECTIONS.UB, "A"]: ["ForwardJump", "FJA5"],
	[DIRECTIONS.UF, "A"]: ["ForwardJump", "FJA5"],
	[DIRECTIONS.B, "B"]: ["ForwardJump", "FJB4"],
	[DIRECTIONS.UB, "B"]: ["ForwardJump", "FJB4"],
}
func groundedAttackTransitions(input, anim):
	if animFinished == anim:
		animFinished = ""
		return groundedStatesMap[input]
	else:
		return ["Idle", anim]
func Idle_Transitions(input):
	return groundedStatesMap[input]
func WalkBackward_Transitions(input):
	return groundedStatesMap[input]
func WalkForward_Transitions(input):
	return groundedStatesMap[input]
func A5_Transitions(input):
	return groundedAttackTransitions(input, "A5")
func B5_Transitions(input):
	return groundedAttackTransitions(input, "B5")
func B6_Transitions(input):
	if get_node("RyuAnimationPlayer").current_animation_position() >= 0.2:
		if !is_on_floor():
			return ["NeutralJump", "B6"]
		elif is_on_floor()
func B4_Transitions(input):
	if is_on_floor() == true:
		get_node("States/NeutralJump").jumpPower = Vector2(0, -200)
		return groundedStatesMap[input]
	else:
		if animFinished == "B4":
			animFinished = ""
			return ["NeutralJump"]
		else:
			return ["NeutralJump", "B4"]
func NeutralJump_Transitions(input):
	if is_on_floor() == true:
		get_node("States/NeutralJump").jumpPower = Vector2(0, -200)
		return groundedStatesMap[input]
	else:
		return neutralJumpingStatesMap[input]
func BackJump_Transitions(input):
	if is_on_floor() == true:
		get_node("States/BackJump").jumpPower = Vector2(-75, -200)
		return groundedStatesMap[input]
	else:
		print(input)
		return backJumpingStatesMap[input]
func ForwardJump_Transitions(input):
	if is_on_floor() == true:
		get_node("States/ForwardJump").jumpPower = Vector2(75, -200)
		return groundedStatesMap[input]
	else:
		return forwardJumpingStatesMap[input]
func NJA5_Transitions(input):
	if is_on_floor() == true:
		get_node("States/NeutralJump").jumpPower = Vector2(0, -200)
		return groundedStatesMap[input]
	if animFinished == "NJA5":
		animFinished = ""
		return neutralJumpingStatesMap[input]
	else:
		return ["NeutralJump", "NJA5"]
func BJA5_Transitions(input):
	if is_on_floor() == true:
		get_node("States/BackJump").jumpPower = Vector2(-75, -200)
		return groundedStatesMap[input]
	if animFinished == "BJA5":
		animFinished = ""
		return backJumpingStatesMap[input]
	else:
		return ["BackJump", "BJA5"]
func FJA5_Transitions(input):
	if is_on_floor() == true:
		get_node("States/ForwardJump").jumpPower = Vector2(75, -200)
		return groundedStatesMap[input]
	if animFinished == "FJA5":
		animFinished = ""
		return forwardJumpingStatesMap[input]
	else:
		return ["ForwardJump", "FJA5"]
func NJB4_Transitions(input):
	if is_on_floor() == true:
		get_node("States/NeutralJump").jumpPower = Vector2(0, -200)
		return groundedStatesMap[input]
	else:
		return ["NeutralJump", "NJB4"]
func BJB4_Transitions(input):
	if is_on_floor() == true:
		get_node("States/BackJump").jumpPower = Vector2(-75, -200)
		return groundedStatesMap[input]
	else:
		return ["BackJump", "BJB4"]
func FJB4_Transitions(input):
	if is_on_floor() == true:
		get_node("States/ForwardJump").jumpPower = Vector2(75, -200)
		return groundedStatesMap[input]
	else:
		return ["ForwardJump", "FJB4"]

func _on_RyuAnimationPlayer_animation_finished(anim_name):
	print(anim_name)
	animFinished = anim_name
