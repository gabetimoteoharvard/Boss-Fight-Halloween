extends Label

var fade
func _ready():
	fade = false
	modulate.a =0
	
	position = get_viewport_rect().size
	position.x/=2
	position.y/=2
	
	position.y += 500
	position.x -= len(text)*5
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fade:
		modulate.a = max(0, modulate.a - 0.025)
		await get_tree().create_timer(0.3).timeout
		
		if modulate.a == 0:
			queue_free()
			
		return
		
	if modulate.a == 1:
		await get_tree().create_timer(1.5).timeout
		fade = true
		
	modulate.a = min(1, modulate.a + 0.025)
	await get_tree().create_timer(0.3).timeout
	
