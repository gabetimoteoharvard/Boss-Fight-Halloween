extends Area2D


@onready var p = $'../../Player'
@onready var sprite = $'AnimatedSprite2D'
@export var dialogue_resource: DialogueResource
@export var start_dialogue = "main"

var player_in = false


func _handle_animation():
	sprite.play("idle")

func _process(delta):
	_handle_dialogue()
	_handle_animation()
	
func _handle_dialogue():
	if player_in:
		var facing_correct = ((((p.position.x - position.x) > 0) and p.sprite.flip_h) or ((p.position.x - position.x) < 0) and not p.sprite.flip_h)
		
		if facing_correct and p.interact:

			p.interact = false
			State.dialogue = true
			if p.position.x - position.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
				
			
			var dist = p.position.x - position.x 
			
			if dist >= 0 and dist < 30:
				p.adjust = [1, position.x + 30]
			elif dist < 0 and dist > -30:
				p.adjust = [-1, position.x - 30]
				
			#DIALOGUE CODE GOES HERE
			var balloon = preload('res://dialogue/large_balloon.tscn').instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(dialogue_resource, start_dialogue)
			
func _on_body_entered(body):
	if body.name == "Player":
		player_in = true

	
func _on_body_exited(body):
	if body.name == "Player":
		player_in = false
