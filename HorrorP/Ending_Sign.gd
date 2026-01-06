extends Area2D

var sign_visible = false
var player_in = false
@onready var p = $'../../../Player'
@export var dialogue_resource: DialogueResource
@export var start_dialogue = "ending_sign"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sign_visible:
		visible = true
	else:
		visible = false
		
	if p.interact and sign_visible:
		p.interact = false
		State.dialogue = true
		
		var balloon = preload('res://dialogue/small_balloon.tscn').instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, start_dialogue)


func _on_body_entered(body):
	if body.name == "Player":
		sign_visible = true
		player_in = true


func _on_body_exited(body):
	if body.name == "Player":
		sign_visible = false
		player_in = false

