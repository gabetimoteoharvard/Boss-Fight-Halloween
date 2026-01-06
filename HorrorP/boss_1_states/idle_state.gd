class_name EnemyIdle
extends CharacterState

@export var actor: Area2D
@export var animator: AnimatedSprite2D
@export var my_collision: CollisionShape2D

@onready var player = actor.player
@onready var time = actor.down_time
var rng = RandomNumberGenerator.new() 

signal attack_ready
signal skull_attack_ready
signal charge_ready
signal teleport_ready

var probabilities = [45, 35, 20]
var signals = [attack_ready, skull_attack_ready, charge_ready]
var choose = []
	
func _ready():
	
	#sets up probabilities for various signals
	for i in range(len(signals)):
		for x in range(probabilities[i]):
			choose.append(i)
			
	
	

func _enter_state():
	set_physics_process(true)
	my_collision.disabled = false
	time = actor.down_time
	animator.play("idle")
	

func _exit_state():
	my_collision.disabled = true
	set_physics_process(false)
	animator.stop()
	
func _physics_process(_delta):
	time -= 1
	if time <= 0:
		
		if abs(player.position.x - actor.position.x) > 200:
			
			teleport_ready.emit()
			return
		
		var val = choose.pick_random()
		signals[val].emit()
	
	if abs(sign(player.position.x - actor.position.x)) > 0:
		actor.scale.x = -1*sign(player.position.x - actor.position.x)
	
	
	
