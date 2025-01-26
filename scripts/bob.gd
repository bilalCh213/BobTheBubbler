extends CharacterBody2D
class_name Bob

@export var transfer_position : Node2D
@export var bubble_fire : PackedScene
@export var shoot_offset : float
@onready var sprite : AnimatedSprite2D = $Sprite

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const MAX_VELOCITY = 800

func _physics_process(delta: float) -> void:
	
	if not is_on_floor() and velocity.length() < MAX_VELOCITY:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("shoot"):
		var new_bubble_fire:BubbleFire = bubble_fire.instantiate() as BubbleFire
		new_bubble_fire.is_left = sprite.flip_h
		new_bubble_fire.global_position = global_position + (Vector2.DOWN * 24)
		new_bubble_fire.global_position.x = new_bubble_fire.global_position.x + (-shoot_offset if new_bubble_fire.is_left else shoot_offset)
		get_tree().root.add_child(new_bubble_fire)
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if velocity.y != 0:
		sprite.play("jump")
	elif velocity.x != 0:
		sprite.play("walk")
	else:
		sprite.play("default")
	
	if velocity.x != 0:
		sprite.flip_h = velocity.x < 0

	move_and_slide()
	
	if Enemy.count <= 0:
		%WinScreen.show()
		var timer = get_tree().create_timer(2.0)
		timer.timeout.connect(reload_scene)

func lose() -> void:
	%Gameover.show()
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(reload_scene)

func reload_scene() -> void:
	get_tree().reload_current_scene()

func _on_bottom_fall_detector_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.global_position.y = transfer_position.global_position.y
