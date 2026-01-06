extends StaticBody2D


# Called when the node enters the scene tree for the first time.
var boss_barrier = false

@export var collision: CollisionShape2D
@export var normal_wall: bool

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if boss_barrier or normal_wall:
		collision.disabled = false
	else:
		collision.disabled = true
		
