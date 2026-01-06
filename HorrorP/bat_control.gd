extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		for i in range(3):
			var _y = position.y - 55 - i*15
			var _x = position.x + 300 + i*60
			var crow = load("res://background_stuff/crow.tscn").instantiate()
			crow.position = Vector2(_x,_y)
			add_sibling(crow)
			
		queue_free()
		
