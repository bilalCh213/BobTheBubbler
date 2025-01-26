extends CharacterBody2D
class_name Enemy

static var count : int = 0

@export_enum("ladybug", "mouse", "slime", "snail") var type : String = "ladybug"
@export var speed : float = 100.0
@export var raycast_left : RayCast2D
@export var raycast_right : RayCast2D

@onready var sprite: AnimatedSprite2D = $Sprite

var direction = 1

func _ready() -> void:
	count = count + 1
	sprite.play(type)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	sprite.flip_h = direction == 1
	
	if velocity.y != 0:
		direction = 0
	elif direction == 0:
		direction = 1 if randf() > 0.5 else -1
	elif direction == 1 and !raycast_right.is_colliding():
		direction = -1
	elif direction == -1 and !raycast_left.is_colliding():
		direction = 1

	move_and_slide()

func _on_enemy_area_entered(body: Node2D) -> void:
	var bob: Bob = body as Bob
	if bob != null:
		bob.lose()
		bob.hide()
