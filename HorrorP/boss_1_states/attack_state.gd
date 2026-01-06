class_name AttackState
extends CharacterState

@export var collision: CollisionShape2D
@export var anim: AnimatedSprite2D
@export var animator: AnimationPlayer
@export var actor: Area2D

signal attack_over

func _enter_state():
	set_physics_process(true)
	collision.disabled = false
	
	#sets sprite2d to attack
	anim.play("attack")
	anim.stop()
	
	#plays actual animation
	animator.play("attack")
	
	
func _exit_state():
	animator.stop()
	actor.down_time = 60
	set_physics_process(false)
	collision.disabled = true
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		attack_over.emit()
		
