extends Node3D

@onready var player = $"../Player"

func _process(delta: float) -> void:
	position = player.position
