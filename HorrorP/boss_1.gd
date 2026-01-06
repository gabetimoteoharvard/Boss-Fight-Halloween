class_name Demon_Boss
extends Area2D

@onready var fire_light = $'PointLight2D'
@onready var skull_mask = $'SkullFace'
@export var world_scene: Node2D
@export var death_scene: CanvasLayer

@export var player: CharacterBody2D
@export var attack_scene: Node2D
@export var left_collision: StaticBody2D
@export var right_collision: StaticBody2D
@export var health_bar: TextureProgressBar
@export var cutscene_area: Area2D

@onready var fms = $'FiniteStateMachine' as FiniteStateMachine

@onready var initial_stage = $'FiniteStateMachine/EnemyStartStage' as StartStage
@onready var idle_state = $'FiniteStateMachine/EnemyIdleState' as EnemyIdle
@onready var attack_state = $'FiniteStateMachine/EnemyAttackState' as AttackState
@onready var skull_state = $'FiniteStateMachine/EnemySkullState' as SkullState
@onready var charge_state = $'FiniteStateMachine/EnemyChargeState' as ChargeState
@onready var teleport_state = $'FiniteStateMachine/EnemyTeleportState' as TeleportState
@onready var death_state = $'FiniteStateMachine/EnemyDeathState' as DeathState

var down_time = 120
var player_inside = false

var total_HEALTH = 40
var curr_HEALTH = 40
var initial_position
@onready var states = [idle_state, attack_state, skull_state, charge_state, teleport_state, death_state]

signal take_damage
signal activate
signal _death

func _ready():
	
	
	initial_position = position
	#sets all states' processes to false at first, prevents every state's code from executing at once
	idle_state.set_physics_process(false)
	teleport_state.set_physics_process(false)
	attack_state.set_physics_process(false)
	charge_state.set_physics_process(false)
	skull_state.set_physics_process(false)
	death_state.set_physics_process(false)
	
	
	skull_mask.visible = false
	
	fire_light.enabled = false
	
	#all possible states that idle can connect to
	
	idle_state.attack_ready.connect(fms.transition.bind(attack_state))
	idle_state.skull_attack_ready.connect(fms.transition.bind(skull_state))
	idle_state.charge_ready.connect(fms.transition.bind(charge_state))
	idle_state.teleport_ready.connect(fms.transition.bind(teleport_state))
	
	#after each state is done, it goes back to an idle state
	initial_stage.back_idle.connect(fms.transition.bind(idle_state))
	attack_state.attack_over.connect(fms.transition.bind(idle_state))
	skull_state.back_idle.connect(fms.transition.bind(idle_state))
	charge_state.back_idle.connect(fms.transition.bind(idle_state))
	teleport_state.back_idle.connect(fms.transition.bind(idle_state))
	
	#death
	_death.connect(fms.transition.bind(death_state))
	
func _physics_process(delta):
	handle_health_bar()
	if player_inside:
		"emits a signal in the player that will let it take damage (if not in invulnerability period)"
		
		if player.invicible == 0:
			player.recoil_direction = [player.position.x - position.x, -200]
			player.damage_color = Color.BLACK
			player.take_damage.emit()
			
		
	
func _on_body_entered(body):
	if body.name == "Player":
		"player is inside the boss"
		player_inside = true


func _on_body_exited(body):
	if body.name == "Player":
		"player is no longer inside"
		player_inside = false


func _on_take_damage():
	curr_HEALTH -= 1
	if curr_HEALTH == 0:
		_death.emit()
	modulate = Color.RED
	await get_tree().create_timer(0.15).timeout
	modulate = Color.WHITE

func handle_health_bar():
	var percentage: float = float(curr_HEALTH)/total_HEALTH
	
	health_bar.value = 100*percentage

func _restart():
	for state in states:
		state.set_physics_process(false)
		
	position = initial_position
	scale.x = 1
	fms.transition(initial_stage)
	cutscene_area.collision.disabled = false
	left_collision.boss_barrier = false
	right_collision.boss_barrier = false
	curr_HEALTH = total_HEALTH
	health_bar.visible = false
	
