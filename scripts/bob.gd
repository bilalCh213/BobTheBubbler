extends CharacterBody2D

@export var transfer_position : Node2D

const SPEED = 300.0
const JUMP_VELOCITY = -720.0
const MAX_VELOCITY = 800

func _physics_process(delta: float) -> void:
	
	if not is_on_floor() and velocity.length() < MAX_VELOCITY:
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _on_bottom_fall_detector_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.global_position.y = transfer_position.global_position.y
