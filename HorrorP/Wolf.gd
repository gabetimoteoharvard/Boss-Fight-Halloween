extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
@onready var anim = $'AnimatedSprite2D' 
@onready var p = $'../../Player'
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var anim = $'AnimatedSprite2D' 
	anim.flip_h = true
	velocity.x = -90
	


func _handle_animation():
	anim.play("running")
	
func _process(delta):
	_handle_animation()
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if position.x - p.position.x < -500:
		queue_free()
		
	move_and_slide()
	

	
	
	
