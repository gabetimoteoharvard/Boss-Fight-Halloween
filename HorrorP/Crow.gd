extends CharacterBody2D

@onready var p = $'../../Player'
	
func _handle_animation():
	var sprite = $'AnimatedSprite2D'
	sprite.play("fly")
	
func _physics_process(delta):
	velocity = Vector2(-105, 0)
	
	if position.x - p.position.x < -500:
		queue_free()
		
	move_and_slide()
	_handle_animation()
	move_and_slide()
