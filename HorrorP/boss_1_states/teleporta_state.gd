class_name TeleportState
extends CharacterState

@export var animation: AnimatedSprite2D
@export var actor: Area2D
var _teleport_time = 20


signal back_idle

func _enter_state():
	
	animation.play("idle")
	actor.visible = false
	_teleport_time = 20
	
	set_physics_process(true)
	
	
	#create particle effects here (somehow?)
	
func _physics_process(_delta):
	
	
	if _teleport_time == 0:
		back_idle.emit()
		#teleport next to player
		var p = actor.player
		actor.position.x = p.position.x - sign(p.position.x - actor.position.x)*50
		
		
	_teleport_time -= 1
	
func _exit_state():
	actor.down_time = 30
	actor.visible = true
	set_physics_process(false)
	#create particle effects here (somehow?)
	
