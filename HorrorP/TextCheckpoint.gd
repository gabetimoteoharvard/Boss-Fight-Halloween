extends Area2D


# Called when the node enters the scene tree for the first time.
@export var text: String
@export var text_scene: CanvasLayer
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	
	if body.name == "Player":
		
		var m_text = load('res://ui_text.tscn').instantiate()
		m_text.text = text
		
		text_scene.add_child(m_text)
		queue_free()
