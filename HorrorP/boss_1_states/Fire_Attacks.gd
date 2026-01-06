extends Area2D

@export var actor: Area2D

# Called when the node enters the scene tree for the first time.
var player_inside
var player
func _ready():
	player_inside = false
	player = actor.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player_inside:
		"emits a signal in the player that will let it take damage (if not in invulnerability period)"
		
		if player.invicible == 0:
			player.recoil_direction = [player.position.x - actor.position.x, -200]
			player.damage_color = Color.BLUE
			player.take_damage.emit()


func _on_body_entered(body):
	if body.name == "Player":
		"player is inside the fire"
		player_inside = true


func _on_body_exited(body):
	if body.name == "Player":
		"player is no longer inside"
		player_inside = false
