extends Node3D

@onready var ray = $floor_ray
@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var state = IdleState.new(self)
@onready var collision_rays = $collision_rays
@onready var mass_center = $mass_center
var gravity = 10
var jump_force = 6
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
	
	collide()
	
func move(move_velocity : Vector3):
	global_position += move_velocity 

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
	rotate(transform.basis.y.normalized(), input.x * delta * fall_rotation_speed)
	rotate_around_point(transform.basis.x.normalized(), input.z * delta * fall_rotation_speed, mass_center.global_position)

func get_velocity() -> Vector3:
	return velocity

func race(delta):
	var input = roller_input.input()
	var right = quaternion * Vector3.RIGHT
	var point = ray.get_collision_point()
	global_position = point
	var normal = ray.get_collision_normal()
	var up = quaternion * Vector3.UP
	var axis_lerp_weight = delta * max(velocity.length() * 0.5, 5)
	var axis_lerp = lerp(up, normal, axis_lerp_weight)
	var floor_forward = axis_lerp.cross(right)
	look_at_direction(floor_forward, axis_lerp)
	
	var slope_velocity = (Vector3.DOWN * gravity).slide(normal) * delta
	velocity = velocity.slide(normal) + slope_velocity
	if velocity.length() < move_speed:
		var move_velocity = forward() * max(0, up.dot(Vector3.UP)) * move_speed * -input.z * delta
		velocity += move_velocity * move_smoothness
	var side_friction_velocity = -right * right.dot(velocity) * delta * side_friction
	velocity += side_friction_velocity
	move((velocity) * delta)
	rotate(quaternion * Vector3.UP, input.x * delta * race_rotation_speed)

func collide():
	var multi_rays = collision_rays.get_colliding_rays()
	if multi_rays:
		for multi_ray in multi_rays:
			var point = multi_ray.get_collision_point()
			var normal = multi_ray.get_collision_normal()
			var ray_length = multi_ray.get_ray_length()
			var ray_position = multi_ray.global_position
			var from_ray_to_point = point - ray_position
			var ray_vector = from_ray_to_point.normalized() * ray_length
			var move_vector = from_ray_to_point - ray_vector
			move(move_vector)
			velocity = velocity.slide(normal.normalized())

func rotate_around_point(axis : Vector3, radian : float, point : Vector3):
	var start_position = global_position
	var point_to_start_position = start_position - point
	var point_to_end_position = point_to_start_position.rotated(axis, radian)
	move(point_to_end_position - point_to_start_position)
	rotate(axis, radian)
