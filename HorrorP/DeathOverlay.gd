extends CanvasLayer


# Called when the node enters the scene tree for the first time.
@export var background: Sprite2D
@export var label: Label
@export var player: CharacterBody2D
signal overlay
var darken

func _ready():
	darken = false
	background.modulate.a = 0
	label.modulate.a = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if darken:
		background.modulate.a = min(1, background.modulate.a + 0.0035)
		label.modulate.a = min(1, label.modulate.a + 0.0025)
		await get_tree().create_timer(1).timeout
	
		
	if background.modulate.a == 1:
		darken = false
		player.current_checkpoint._save()
		await get_tree().create_timer(2.5).timeout 
		visible = false
		
		background.modulate.a = 0
		label.modulate.a = 0
		set_process(false)
		


func _on_overlay():
	darken = true
	visible = true
	background.modulate.a = 0
	label.modulate.a = 0
	set_process(true)
