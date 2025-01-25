extends CharacterBody3D

@onready var visual = $CollisionShape3D
@onready var staminaCooldown = $"StaminaCooldown"
@onready var text = $Label

@export var states : String = "resting"

@export var moveSpeed : Vector3

@export var staminaCounter : float = 3
@export var timerJustEnded : bool

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
	
	
	if inputMovement != Vector2(0, 0):
		rotDirRadians = atan2(inputMovement.x, inputMovement.y)
		rotDir = rad_to_deg(rotDirRadians)
		visual.transform.basis = lerp(visual.transform.basis, Basis(axisY, rotDirRadians), 0.15)
	
	velocity = moveSpeed
	
	move_and_slide()
	
	text.set_text((str(staminaCounter)) + " :: " + (str(staminaCooldown.time_left)) + " :: " + (str(flyingMultiplier)) + " :: " + states + " :: " + str(moveSpeed))
	
	print(flyingMultiplier)
	
	pass
func _stamina(delta: float) -> void:
	if (Input.is_action_pressed("sprint")):
		staminaCounter = staminaCounter - 1 * delta
	if staminaCounter >= 1:
		staminaCooldown.start()
	if timerJustEnded == true:
		staminaCounter = staminaCounter + 1 * delta
	pass
func _on_stamina_cooldown_timeout() -> void:
	timerJustEnded = true
	pass # Replace with function body.
