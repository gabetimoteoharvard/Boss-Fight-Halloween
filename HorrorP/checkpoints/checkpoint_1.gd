class_name LampCheckpoint
extends Checkpoint


@export var player: CharacterBody2D
var s_position
@export var boss: Area2D
@export var camera: Camera2D

func _save():		
	player._restart()
	if not State.boss_defeated:
		boss._restart()
	camera.position = player.position
	

func _on_body_entered(body):
	if body.name == "Player":
		if not (body.current_checkpoint is Checkpoint):
			s_position = body.position
			body.current_checkpoint = self
