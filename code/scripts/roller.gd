extends Node3D

@onready var ray = $floor_ray
@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var state = IdleState.new(self)
var gravity = 10
var jump_force = 5
var move_speed = 15
var move_smoothness = 0.5
var race_rotation_speed = 2
var fall_rotation_speed = 5
var side_friction = 2
var floor_angle = 45
var velocity := Vector3.ZERO
var roller_input := KeyInput.new()

func _ready():
	anim_tree.active = true

func _physics_process(delta):
	var next_state = state.next_state()
	if state != next_state:
		state.exit()
		state = next_state
	state.update(delta)
	
func move(velocity : Vector3):
	global_position += velocity 

func look_at_direction(direction : Vector3, axis : Vector3):
	look_at(global_position + direction, axis)

func forward() -> Vector3:
	return quaternion * Vector3.FORWARD

func floor_check():
	var angle_check = ray.get_collision_normal().angle_to(quaternion * Vector3.UP) < (floor_angle * PI / 180)
	return ray.is_colliding() && angle_check

func jump():
	velocity += ray.get_collision_normal() * jump_force

func fall(delta):
	var input = roller_input.input()
	velocity.y -= gravity * delta
	move(velocity * delta)
	rotate(quaternion * Vector3.UP, input.x * delta * fall_rotation_speed)

func get_velocity() -> Vector3:
	return velocity

func race(delta):
	var input = roller_input.input()
	var right = quaternion * Vector3.RIGHT
	var point = ray.get_collision_point()
	global_position = point
	var normal = ray.get_collision_normal()
	var axis_lerp = lerp(quaternion * Vector3.UP, normal, delta * velocity.length() * 0.5)
	var floor_forward = axis_lerp.cross(right)
	look_at_direction(floor_forward, axis_lerp)
	
	var slope_velocity = (Vector3.DOWN * gravity).slide(normal) * delta
	velocity = velocity.slide(normal) + slope_velocity
	if velocity.length() < move_speed:
		var move_velocity = forward().slide(Vector3.UP) * move_speed * -input.z * delta
		velocity += move_velocity * move_smoothness
	var side_friction_velocity = -right * right.dot(velocity) * delta * side_friction
	velocity += side_friction_velocity
	move((velocity) * delta)
	rotate(quaternion * Vector3.UP, input.x * delta * race_rotation_speed)

func shape_local_collision_point(shape : ShapeCast3D) -> Vector3:
	var global_point = shape.get_collision_point(0)
	var local_point = quaternion.inverse() * (global_point - global_position)
	var shape_local_position = shape.position + shape.target_position
	var shape_point = local_point - shape_local_position
	return shape_point
