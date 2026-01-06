extends TextureProgressBar


# Called when the node enters the scene tree for the first time.

@export var camera: Camera2D
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	var screenSize = Vector2(0,0)
	screenSize.x = get_viewport().get_visible_rect().size.x # Get Width
	screenSize.y = get_viewport().get_visible_rect().size.y # Get Height
	
	#position = camera.position
	#position = Vector2(position.x - 150, position.y - screenSize.y/13)
