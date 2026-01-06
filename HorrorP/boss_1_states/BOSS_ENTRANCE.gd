extends Area2D


@export var collision: CollisionShape2D
@export var world_scene: Node2D
@export var m_boss: Area2D
@export var barrier_left: StaticBody2D
@export var barrier_right: StaticBody2D


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.name == "Player" and not collision.disabled:
		collision.disabled = true
		
		barrier_left.boss_barrier = true
		barrier_right.boss_barrier = true
		
		world_scene.cutscene = true
		world_scene.cutscene_focus = m_boss.position
		
		m_boss.activate.emit()
		
