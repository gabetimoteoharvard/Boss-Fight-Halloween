class_name StartStage
extends CharacterState


# Called when the node enters the scene tree for the first time.
@export var sprite: AnimatedSprite2D
@export var actor: Area2D

signal back_idle

var timer
func _enter_state():
	set_physics_process(true)
	sprite.play("idle")
	timer = -1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	if timer == -1:
		return
		
	timer = max(timer - 1 , 0)
	if timer == 80:
		actor.world_scene.cutscene = false
		actor.health_bar.visible = true
		
	if not timer:
		back_idle.emit()

func _exit_state():
	set_physics_process(false)
	sprite.stop()

func _on_boss_1_activate():
	timer = 60*7
