class_name SkullState
extends CharacterState

@export var anim: AnimatedSprite2D
@export var mask_anim: AnimatedSprite2D
@export var actor: Area2D
@export var collision: CollisionShape2D


signal back_idle
var rng = RandomNumberGenerator.new()
var num_of_skulls
var activate
var time

func _enter_state():
	anim.play("idle")
	mask_anim.play("idle")
	actor.skull_mask.visible = true
	actor.skull_mask.position = Vector2(-2,-26)
	
	
	num_of_skulls = rng.randi_range(4,8)
	collision.disabled = false
	activate = false
	time = 40
	set_physics_process(true)

func _exit_state():
	anim.stop()
	actor.skull_mask.visible = false
	actor.down_time = 70
	set_physics_process(false)
	collision.disabled = true

func _physics_process(_delta):
	
	if abs(sign(actor.player.position.x - actor.position.x)) > 0:
		actor.scale.x = -1*sign(actor.player.position.x - actor.position.x)
		
	if activate:
		var skull = load("res://boss_1_states/skull_fire.tscn").instantiate()
		skull.position = Vector2(actor.position.x, actor.position.y+70)
		actor.attack_scene.add_child(skull)
	
		activate = false
		num_of_skulls-=1
		time = rng.randf_range(60,80)
	
	if time:
		time = max(time - 1, 0)
	if time == 0:
		activate = true
	if num_of_skulls == 0:
		back_idle.emit()
