extends Area2D
class_name BubbleFire

@export var speed:float = 100
@export var decay:float = 50

var is_left:bool = false

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1.25, 1.25), 0.25)

func _process(delta: float) -> void:
	global_position.x += speed * delta * (-1 if is_left else 1)
	speed -= decay * delta
	if speed <= 0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	
	if body is Enemy:
		body.queue_free()
		Enemy.count = Enemy.count - 1
