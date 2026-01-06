extends Area2D


var start
var v: int
@export var anim: AnimatedSprite2D

var player
var death_canvas
var player_inside
func _ready():
	anim.play("moving")
	start = position.x
	v = -90 * sign($'../../Boss_1'.scale.x)
	scale.x = $'../../Boss_1'.scale.x
	
	player = $'../../Boss_1'.player
	death_canvas = $'../../Boss_1'.death_scene
	player_inside = false
	

func _physics_process(delta):
	
	if player_inside:
		"emits a signal in the player that will let it take damage (if not in invulnerability period)"
		
		if player.invicible == 0:
			player.recoil_direction = [0, -300]
			player.damage_color = Color.BLACK
			player.take_damage.emit()
			
	
	position.x += v*delta
	
	if death_canvas.background.modulate.a == 1 or abs(start - position.x) > 600:
		queue_free()
	


func _on_body_entered(body):
	if body.name == "Player":
		"player is inside the attack"
		player_inside = true



func _on_body_exited(body):
	if body.name == "Player":
		"player is no longer inside"
		player_inside = false
