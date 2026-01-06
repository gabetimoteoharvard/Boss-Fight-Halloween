class_name ChargeState
extends CharacterState

@export var actor: Area2D
@export var anim: AnimatedSprite2D
@export var my_collision: CollisionShape2D

var speed
var player

var drop_down
var float_up
var charge

var start_vertical_position
var start_horizontal_position
var my_scale


signal back_idle

func _enter_state():
	set_physics_process(true)
	my_collision.disabled = false
	
	anim.play('idle')
	player = actor.player
	speed = 0
	
	start_vertical_position = actor.position.y
	start_horizontal_position = actor.position.x
	
	drop_down = true
	charge = false
	
	float_up = false
	
	my_scale = 1
	
	
	
func _physics_process(delta):
	
	if drop_down:
		
		actor.scale.x = sign( actor.position.x - player.position.x)
		actor.position.y += 110*delta
		
		if actor.position.y - start_vertical_position >= 100:
			drop_down = false
			charge = true
			my_scale = sign(actor.scale.x)
			speed = -220 * sign(actor.position.x - player.position.x)
			
	if charge:
		actor.scale.x = my_scale
		actor.position.x+=speed*delta
		
		if (speed < 0 and actor.position.x <= actor.left_collision.position.x + 50) or (speed > 0 and actor.position.x >= actor.right_collision.position.x - 50):
			speed = 0
			float_up = true
			charge = false
			
		
	if float_up:
		actor.scale.x = sign( actor.position.x - player.position.x)
		actor.position.y -= 110*delta
		if actor.position.y <= start_vertical_position:
			back_idle.emit()
		
	
	
	
func _exit_state():
	actor.down_time = 60
	set_physics_process(false)
	my_collision.disabled = true
	anim.stop()
