extends Node2D
# Called when the node enters the scene tree for the first time.
var cutscene
var cutscene_focus

func _ready():
	cutscene = false
	cutscene_focus = Vector2(0,0)
	
	var canvas_modulate = CanvasModulate.new()
	canvas_modulate.color = Color(0.3,0.25,0.75, 1)
	
	add_child(canvas_modulate)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	#canvas_modulate.color = Color(0.75,0.25,0.75, 1) MORE VIBRANT, PURPLISH TONE
