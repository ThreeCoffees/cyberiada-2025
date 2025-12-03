extends Node

@export var stair_detection_area: Area3D
@export var stair_obstacle_detection_area: Area3D
@export var stair_climb_velocity: float = 2.0

var stair_detected: int = 0
var stair_obstacle_detected: int = 0

func _ready() -> void:
	stair_detection_area.body_entered.connect(func(body: Node3D): stair_detected += 1)
	stair_detection_area.body_exited.connect(func(body: Node3D): stair_detected -= 1)

	stair_obstacle_detection_area.body_entered.connect(func(body: Node3D): stair_obstacle_detected += 1)
	stair_obstacle_detection_area.body_exited.connect(func(body: Node3D): stair_obstacle_detected -= 1)

func _physics_process(delta: float) -> void:
	if is_stair_climbing():
		get_parent().velocity.y = stair_climb_velocity;

func is_stair_climbing() -> bool:
	if get_parent().input_dir.y >= 0:
		return false
	if stair_detected <= 0:
		return false
	if stair_obstacle_detected > 0:
		return false
	print("stair climbing")
	return true
