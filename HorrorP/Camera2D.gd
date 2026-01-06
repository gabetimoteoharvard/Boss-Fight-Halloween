extends Camera2D


# Called when the node enters the scene tree for the first time.
@export var world_scene: Node2D
@export var player: CharacterBody2D
@export var cam_speed: int

var go_position 

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not world_scene.cutscene:
		
		go_position = Vector2(player.position.x , player.position.y - 30)
		position = position.move_toward(go_position, cam_speed*delta)
		return 
	
	go_position = world_scene.cutscene_focus
	position = position.move_toward(go_position, cam_speed*delta)
		
		
		
	
	
	
