extends Node2D


var velocity
var fly
@onready var player = $'../../Player'

func _ready():
	velocity = Vector2(0,0)
	fly = false

func _handle_animation():
	var sprite = $'AnimatedSprite2D'
	
	if not fly:
		sprite.play("idle")
	else:
		sprite.play("fly")

func _process(delta):
	_handle_animation()
	if fly and player.position.x - position.x >= 500:
		queue_free()
	
	position += velocity*delta


func _on_body_entered(body):
	
	if body.name == "Player":
		velocity = Vector2(-120, -40)
		fly = true
