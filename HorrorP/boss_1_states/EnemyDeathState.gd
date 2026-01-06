class_name DeathState
extends CharacterState


# Called when the node enters the scene tree for the first time.
@export var sprite: AnimatedSprite2D
@export var actor: Area2D
var ls_pos = [Vector2(-20, 0),Vector2(0,0), Vector2(40,0), Vector2(20,0), Vector2(-20, -20), Vector2(0,-40), Vector2(0,-20), Vector2(0, 20), Vector2(-40,0)]
var curr = 0
var loop = 0
var vector = ls_pos[curr]

func _enter_state():
	State.boss_defeated = true
	actor.set_physics_process(false)
	actor.health_bar.value = 0
	

	
	curr = 0
	loop = 0
	vector = ls_pos[curr]
	
	sprite.visible = true
	sprite.play('explode')
	set_physics_process(true)
	
	
func _physics_process(_delta):
	vector = ls_pos[curr]
	sprite.position = vector
	
	if loop == 2:
		#dead '_', deactivate barriers, let script know the boss is dead, etc.
		actor.left_collision.boss_barrier = false
		actor.right_collision.boss_barrier = false
		actor.health_bar.queue_free()
		var explosion = load("res://art_ui/explosion_effect.tscn").instantiate()
		explosion.position = Vector2(actor.position.x, actor.position.y - 40)
		
		actor.add_sibling(explosion)
		actor.queue_free()
		
	

func _on_explosion_animation_looped():	
	if curr < len(ls_pos) - 1:
		curr+=1
		return

		
	curr = 0
	loop+=1
		
	
