extends CharacterBody3D

#region References
@onready var visual = $CollisionShape3D
@onready var staminaCooldown = $"StaminaCooldown"
@onready var text = $Label
@onready var text2 = $Label2
@onready var text3 = $Label3
#endregion

#region Signals
signal noStamina
signal staminaRecharge
signal staminaValues(counter, state, delta)
#endregion

#region Speed Values
@export var normalSpeed : float = 10
@export var flyingMultiplier : float = 1
@export var moveSpeed : Vector3
@export var currentSpeed : Vector3
#endregion

#region Sprinting Values
var canReduce : bool
var charging : bool
var coolDownActive : bool = false
var isFull : bool
var sendFast : bool = true
@export var staminaCounter : float = 3
@export var timerJustEnded : bool = false
@export var canCharge : bool = false
@export var isSprinting : bool = false
#endregion

#region Input Values
@export var inputMovement : Vector2
@export var inputDir : Vector3
@export var rotDir : float
@export var rotDirRadians : float
var axisY : Vector3 = Vector3(0, 1, 0)
var desiredAngle : float
#endregion

@export var states : String = "resting"

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
	
	#text.set_text(states + " :: :: " + (str(staminaCounter)) + " :: " + (str(staminaCooldown.time_left)) + " :: " + (str(flyingMultiplier)) + " :: " + " :: " + str(moveSpeed) + " :|: " + "isSprinting" + " :: " + str(isSprinting) + " :|: " + "canCharge" + " :: " + str(canCharge) + " :|: " + str(timerJustEnded))
	text.text = ("Stamina : " + str(staminaCounter) + " || " + "Cooldown : " + str(staminaCooldown.time_left))
	text2.text = str(currentSpeed) + " :: states :: " + states
	text3.text = "Can Reduce : " + str(canReduce) + " || " + "Is charging : " + str(charging) + " || " + "Can Charge : " + str(canCharge) + " || " + "Is Full : " + str(isFull)
	
	pass
	
func _stamina(delta: float) -> void:
	
	if staminaCounter >= 0.5:
		if Input.is_action_pressed("sprint"):
			if !charging:
				canReduce = true
				coolDownActive = false
				flyingMultiplier = 1
		else:
			canReduce = false
	else:
		canReduce = false
	
	if canReduce == true:
		if !coolDownActive:
			flyingMultiplier = 1.5
		staminaCounter = staminaCounter - 1 * delta
		pass
	if (staminaCounter >= 1 && staminaCounter <= 1.1 && canReduce):
		noStamina.emit()
		pass
	if (isFull == false && sendFast == true && !canReduce && !charging):
		sendFast = true
		noStamina.emit()
		pass
	if staminaCounter < 3:
		if !canReduce:
			if canCharge == true:
				if !coolDownActive:
					charging = true
					staminaCounter = staminaCounter + 1 * delta
					flyingMultiplier = 1
		isFull = false
	else:
		canCharge = false
		isFull = true
	
	if canCharge == true && staminaCounter >= 1.5:
		charging = false
		coolDownActive = false
	elif canCharge == true && staminaCounter <= 1.5:
		charging = true
		
	if charging == false && canReduce:
		canCharge = false
	pass
	
func _on_no_stamina() -> void:
	flyingMultiplier = 1
	staminaCooldown.start()
	coolDownActive = true
	sendFast = false
	pass # Replace with function body.
	
func _on_stamina_cooldown_timeout() -> void:
	canCharge = true
	staminaRecharge.emit()
	coolDownActive = false
	sendFast = true
	pass # Replace with function body.
	
func _on_stamina_recharge() -> void:
	pass # Replace with function body.
	
#func _stamina2nd(delta: float) -> void:
	#
	#staminaValues.emit(staminaCounter, states, delta)
	#
	#pass
	#
#func _stamina(delta: float) -> void:
	#if (Input.is_action_pressed("sprint")) && (staminaCounter > 0):
		#states = "sprinting"
		#isSprinting = true
		#staminaCounter = staminaCounter - 1 * delta
		#print("Rest")
#
	#
	#if (Input.is_action_just_released("sprint")):
		##staminaOff.emit()
		##states = "sprinting not"
		##isSprinting = false
		##staminaCooldown.start()
		##print("Counter Begin")
		#pass
	#
	#if timerJustEnded == true:
		#if staminaCounter >= -0.01 && staminaCounter <= 3.01 && isSprinting == false:
			#staminaCounter = staminaCounter + 1 * delta
			##print("Recharge")
	#
	#if staminaCounter > 0 && staminaCounter <= 3 && isSprinting == false:
		#canCharge = true
		#
	#if staminaCooldown.time_left != 0:
		#timerJustEnded = false
	#
	#else:
		#canCharge = false
	#
	#if isSprinting:
		#flyingMultiplier = 1.5
	#else:
		#flyingMultiplier = 1
	#
	#pass
#func _on_stamina_cooldown_timeout() -> void:
	#timerJustEnded = true
	#print("Counter Ended")
	#pass # Replace with function body.
#
#func _on_stamina_off() -> void:
	#states = "sprinting not"
	#isSprinting = false
	#staminaCooldown.start()
	#print("Counter Begin")
	#
	#pass # Replace with function body.
#func _on_stamina_values(counter: Variant, state: Variant, delta: Variant) -> void:
	#if counter >= 0.15 && counter <= 0.16:
		#states = "sprinting not"
		#isSprinting = false
	#if states == "sprinting not":
		#isSprinting = false
		#staminaCooldown.start()
		#print("Counter Begin")
		#states = "resting"
	#pass # Replace with function body.
