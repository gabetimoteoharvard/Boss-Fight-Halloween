extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		var _y = position.y
		var _x = position.x + 300
		
		var wolf = load("res://background_stuff/Wolf.tscn").instantiate()
		wolf.position = Vector2(_x,_y)
		add_sibling(wolf)
		queue_free()
		
		
