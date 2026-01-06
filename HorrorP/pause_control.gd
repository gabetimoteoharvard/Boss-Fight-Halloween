extends Node2D


# Called when the node enters the scene tree for the first time.
var mouse_inside
@export var player: CharacterBody2D
@export var sprite: AnimatedSprite2D
var menu

func _ready():
	mouse_inside = false
	sprite.play('pause')


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.dead:
		return 
		
	var click = Input.is_action_just_pressed("click")
	
	if mouse_inside and click:
		if !get_tree().paused:
			_pause()
			
			var pos = get_viewport_rect().size
			var m = load('res://pause_menu.tscn').instantiate()
			m.position = Vector2(pos.x/2, pos.y/2)
			
			add_child(m)
		
	
func _pause():
	if !get_tree().paused:
		State.game_paused = true
		get_tree().set_deferred("paused", true)
		sprite.play('resume')

func _resume():
	if get_tree().paused:
		State.game_paused = false
		get_tree().set_deferred("paused", false)
		sprite.play('pause')


func _on_collision_detection_mouse_entered():
	mouse_inside = true


func _on_collision_detection_mouse_exited():
	mouse_inside = false
