extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 5.0
@export var camera: Camera3D
@export var mouse_sensitivity: float = 5

var input_dir: Vector2
var move_dir: Vector3
var look_dir: Vector2

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		look_dir = event.relative * 0.001
		_rotate_camera()

func _rotate_camera() -> void:
	rotate_y(-look_dir.x * mouse_sensitivity) 
	camera.rotation.x = clamp(camera.rotation.x - look_dir.y * mouse_sensitivity, -1.5, 1.5)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump_velocity.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_dir:
		velocity.x = move_dir.x * speed
		velocity.z = move_dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
