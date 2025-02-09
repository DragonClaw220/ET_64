extends CharacterBody3D

@onready var visual = $CollisionShape3D
@onready var staminaCooldown = $"StaminaCooldown"
@onready var text = $Label
@onready var text2 = $Label2

@export var states : String = "resting"

@export var moveSpeed : Vector3
@export var currentSpeed : Vector3

@export var staminaCounter : float = 3
@export var timerJustEnded : bool = false
@export var canCharge : bool = false
@export var isSprinting : bool = false

@export var normalSpeed : float = 10
@export var flyingMultiplier : float = 1

@export var rotDir : float
@export var rotDirRadians : float
var desiredAngle : float

var axisY : Vector3 = Vector3(0, 1, 0)

@export var inputMovement : Vector2
@export var inputDir : Vector3

func _ready() -> void:
	
	visual.transform.basis = Basis(axisY, rotDirRadians)
	pass

func _physics_process(delta: float) -> void:
	
	_stamina(delta)
	
	inputMovement = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	
	inputDir = Vector3(inputMovement.x, 0, inputMovement.y)
	
	moveSpeed = inputDir.normalized() * normalSpeed * flyingMultiplier
	
	if currentSpeed != moveSpeed:
		currentSpeed = lerp(currentSpeed, moveSpeed, 0.2)
		pass
	
	if inputMovement != Vector2(0, 0):
		rotDirRadians = atan2(inputMovement.x, inputMovement.y)
		rotDir = rad_to_deg(rotDirRadians)
		visual.transform.basis = lerp(visual.transform.basis, Basis(axisY, rotDirRadians), 0.15)
	
	velocity = currentSpeed
	
	move_and_slide()
	
	text.set_text(states + " :: :: " + (str(staminaCounter)) + " :: " + (str(staminaCooldown.time_left)) + " :: " + (str(flyingMultiplier)) + " :: " + " :: " + str(moveSpeed) + " :|: " + "isSprinting" + " :: " + str(isSprinting) + " :|: " + "canCharge" + " :: " + str(canCharge) + " :|: " + str(timerJustEnded))
	text2.text = str(currentSpeed)
	
	pass
func _stamina(delta: float) -> void:
	
	if (Input.is_action_pressed("sprint")) && (staminaCounter > 0):
		states = "sprinting"
		isSprinting = true
		staminaCounter = staminaCounter - 1 * delta
		print("Rest")
	
	if (Input.is_action_just_released("sprint")):
		states = "sprinting not"
		isSprinting = false
		staminaCooldown.start()
		print("Counter Begin")
	
	if timerJustEnded == true:
		if staminaCounter >= -0.02 && staminaCounter <= 3.2 && isSprinting == false:
			staminaCounter = staminaCounter + 1 * delta
			#print("Recharge")
	
	if staminaCounter > 0 && staminaCounter <= 3 && isSprinting == false:
		canCharge = true
		
	if staminaCooldown.time_left != 0:
		timerJustEnded = false
	
	else:
		canCharge = false

	pass
func _on_stamina_cooldown_timeout() -> void:
	timerJustEnded = true
	print("Counter Ended")
	pass # Replace with function body.
