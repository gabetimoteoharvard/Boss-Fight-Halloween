extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@export var world_scene: Node2D

var jumped = false
var jump_key_pressed = false
var attack = false
var interact = false
var direction = 0
var adjust = [0,0]

var invicible = 0
var recoil = false
var recoil_direction = [0,0]
var recoiling = false
var damage_color = Color.BLACK

@export var health_bar: TextureProgressBar
var total_HEALTH = 5
var curr_HEALTH = 5

var dead = false
var death_recoil = false
@export var death_overlay: CanvasLayer
signal take_damage

var current_checkpoint: Checkpoint

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite = $AnimatedSprite2D
@onready var attack_animation = $'AnimationPlayer'
@onready var sword_collision = $'Sword_W/SwordCollision'

func _reset_attributes():
	jumped = false
	jump_key_pressed = false
	attack = false
	interact = false
	direction = 1
	adjust = [0,0]

	invicible = 0
	recoil = false
	recoil_direction = [0,0]
	recoiling = false
	
	dead = false
	death_recoil = false
	
func _ready():
	sword_collision.disabled = true
	
	
func flash():
	if not dead and invicible != 0:
		if invicible % 3 == 0:
			sprite.modulate = Color.WHITE
		else:
			sprite.modulate = damage_color
	else:
		sprite.modulate = Color.WHITE
	
	
func _handle_animation(dir):
	
	#recoiling = animation
	if dead:
		if not (sprite.get_animation() == "hurt"):
			sprite.play("hurt")
		if sprite.get_frame() == 2:
			sprite.set_frame_and_progress(2,0)
		return 
		
	
	if recoiling:
		sprite.play("hurt")
		recoiling = false
	
	if recoil:
		if sprite.get_frame() == 2:
			sprite.set_frame_and_progress(2,0)
			
		return
		
	#direction sprite is facing
	if dir < 0:
		sprite.flip_h = true
		sword_collision.position.x = -35
	elif dir > 0:
		sprite.flip_h = false
		sword_collision.position.x = 33
	
	#jumping mechanics
	if jump_key_pressed: #and not attack:
		jump_key_pressed = false
		if attack:
			attack = false
			attack_animation.stop()
		sprite.play('jump')
	
	if velocity.y > 0 and sprite.get_animation() != "jump" and not attack:
		jumped = true
		sprite.play('jump')
		sprite.set_frame_and_progress(4,0)
		
	if velocity.y > 0 and sprite.get_frame() == 4 and not attack:
		sprite.set_frame_and_progress(4, 0)
	
		
	#moving mechanics
	if not (jumped or attack):
		if velocity.x == 0:
			sprite.play("idle")
		else:
			sprite.play("run")
	
	if attack:
		#changes sprite to attack sprite
		sprite.play("attack")
		sprite.stop()
		
		#plays actual animation
		attack_animation.play("attack")
		
		
func _adjust():
	if adjust[0] != 0:
		velocity.x = adjust[0] * 25
		direction = sign(velocity.x)
		
		if (adjust[0] > 0 and position.x >= adjust[1]) or (adjust[0] < 0 and position.x <= adjust[1]):
			if adjust[0] < 0:
				sprite.flip_h = false
			else:
				sprite.flip_h = true
			velocity.x = 0
			adjust = [0,0]
			direction = 0
			
			
	
func handle_recoil():
	if not death_recoil and dead:
		return
	if recoil_direction[0] != 0 or recoil_direction[1] != 0:
		
		velocity.x = 160*sign(recoil_direction[0])
		velocity.y = recoil_direction[1]
		recoiling = true
		recoil_direction = [0,0]
	death_recoil = false

		
func _physics_process(delta):
	
	invicible = max(0, invicible - 1)
	_adjust()
	flash()
	_handle_animation(direction)
	handle_health_bar()
	handle_recoil()
	move_and_slide()
	
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, 250)
	else:
		jumped = false
		recoil = false
		
	if dead:
		velocity.x = max(velocity.x - 1.5, 0)
		return 
	if world_scene.cutscene:
		velocity.x = 0
		return
		
	if State.dialogue:
		velocity = Vector2(0,0)
		return
	if recoil:
		return
	
	interact = false
	if is_on_floor() and Input.is_action_just_pressed("interact"):
		interact = true

	# Handle Jump.
	if Input.is_action_just_pressed("ui_select") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumped = true
		jump_key_pressed = true
		
			
	
	if Input.is_action_just_pressed("attack") and not attack:
		attack = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	

	
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		attack = false


func _on_take_damage():
	if dead:
		return 
		
	curr_HEALTH -= 1
	if curr_HEALTH <= 0:
		dead = true
		death_recoil = true
		
		await get_tree().create_timer(3).timeout
		death_overlay.overlay.emit()
		
		return 
		
	invicible = 120
	recoil = true
	
	
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	
func handle_health_bar():
	var percentage: float = float(curr_HEALTH)/total_HEALTH
	
	health_bar.value = 100*percentage
	
	
	
func _on_sword_w_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area is Demon_Boss:
		area.take_damage.emit()
		
func _restart():
	set_physics_process(false)
	position = current_checkpoint.s_position
	position.y -= 200

	_reset_attributes()
	curr_HEALTH = total_HEALTH
	set_physics_process(true)
	
