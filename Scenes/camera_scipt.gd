extends Camera3D

@onready var player = $"../Player"
@onready var boundaries = $Area3D
@onready var trigger = $Area3D2
@onready var cameraPos = $"../PlayerCenter/CameraPos"
@onready var offsetTime = $OffsetTimer

@export var playerInsideTrigger : bool
@export var followSpeed : float = 0.0

func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
#	if !playerInsideTrigger:
#		position = lerp(Vector3(position.x, position.y, position.z), Vector3(cameraPos.global_position.x, cameraPos.global_position.y, cameraPos.global_position.z), followSpeed * delta)
	position = cameraPos.global_position
	
	var neededOffset : Vector2 = Vector2(player.inputMovement.x, player.inputMovement.y)
	var camOffset : Vector2 = Vector2(h_offset, v_offset)
	
	h_offset = lerp(h_offset, neededOffset.x * 8, 0.7 * delta)
	v_offset = lerp(v_offset, neededOffset.y * -5, 0.7 * delta)

	pass

#func _on_area_3d_2_body_entered(body: Node3D) -> void:
#	print("Inicio")
#	offsetTime.start(0.3)
#	await offsetTime.timeout
#	playerInsideTrigger = true
#	print("Algo entro")
#	pass # Replace with function body.
#	
#func _on_area_3d_2_body_exited(body: Node3D) -> void:
#	print("Inicio")
#	offsetTime.start(0.3)
#	await offsetTime.timeout
#	playerInsideTrigger = false
#	print("Algo salio")
#	pass # Replace with function body.
#
#func _on_area_3d_body_entered(body: Node3D) -> void:
#	followSpeed = 0.5
#	pass # Replace with function body.
#	
#func _on_area_3d_body_exited(body: Node3D) -> void:
#	followSpeed = 1.5
#	pass # Replace with function body.
#	
