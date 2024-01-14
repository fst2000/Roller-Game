extends Node3D

@onready var floor_ray = $floor_ray
@onready var anim_player = $AnimationPlayer
@onready var anim_tree = $AnimationTree
@onready var state = IdleState.new(self)
@onready var collision_rays = $collision_rays
@onready var mass_center = $mass_center
var gravity = 20
var jump_force = 8 
var move_speed = 24
var move_smoothness = 0.5
var race_rotation_speed = 2
var fall_rotation_speed = 5
var side_friction = 2
var floor_angle = 45
var crash_velocity = 10
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

func move(move_velocity : Vector3):
	global_position += move_velocity 

func look_at_direction(direction : Vector3, axis : Vector3):
	look_at(global_position + direction, axis)

func forward() -> Vector3:
	return quaternion * Vector3.FORWARD

func floor_check():
	var normal = floor_ray.get_collision_normal()
	var normal_velocity_dot = normal.dot(velocity.normalized())
	var angle_check = normal.angle_to(quaternion * Vector3.UP) < (floor_angle * PI / 180)
	return floor_ray.is_colliding() && angle_check && normal_velocity_dot < 0.1

func jump():
	velocity += floor_ray.get_collision_normal() * jump_force

func fall(delta):
	var input = roller_input.input()
	velocity.y -= gravity * delta
	move(velocity * delta)

func get_velocity() -> Vector3:
	return velocity

func race(delta):
	var input = roller_input.input()
	var right = basis.x
	var up = basis.y
	if velocity.length() < move_speed:
		var move_velocity = forward() * max(0, up.dot(Vector3.UP)) * move_speed * -input.z * delta
		velocity += move_velocity * move_smoothness
	var side_friction_velocity = -right * right.dot(velocity) * delta * side_friction
	velocity += side_friction_velocity
	slide(delta)
	rotate(quaternion * Vector3.UP, input.x * delta * race_rotation_speed)

func collide():
	collision_rays.force_raycast_update()
	var multi_rays = collision_rays.get_colliding_rays()
	if multi_rays:
		for multi_ray in multi_rays:
			var point = multi_ray.get_collision_point()
			var normal = multi_ray.get_collision_normal()
			var from_start_to_point = (point - multi_ray.global_position)
			var ray_vector = from_start_to_point.normalized() * multi_ray.get_ray_length()
			var move_vector = from_start_to_point - ray_vector
			move(move_vector)
			velocity = velocity.slide(normal.normalized())

func rotate_around_point(axis : Vector3, radian : float, point : Vector3):
	var start_position = global_position
	var point_to_start_position = start_position - point
	var point_to_end_position = point_to_start_position.rotated(axis, radian)
	move(point_to_end_position - point_to_start_position)
	rotate(axis, radian)

func slide(delta):
	var point = floor_ray.get_collision_point()
	global_position = point
	var normal = floor_ray.get_collision_normal()
	var right = basis.x
	var up = basis.y
	var axis_lerp_weight = delta * clamp(velocity.length() * 1.5, 2, 15)
	var axis_lerp = lerp(up, normal, axis_lerp_weight)
	var floor_forward = axis_lerp.cross(right)
	look_at_direction(floor_forward, axis_lerp)
	var slope_velocity = Vector3.DOWN * gravity * delta
	velocity = velocity.slide(normal) + slope_velocity
	move((velocity) * delta)
	
func set_axis(axis : Vector3):
	var look_dir = axis.cross(basis.x)
	look_at_direction(look_dir, axis)

func flip(delta):
	var input = roller_input.input()
	var rot_x = input.z
	var rot_y = input.x
	var rot_z = roller_input.turn()
	rotate(basis.y.normalized(), rot_y * delta * fall_rotation_speed)
	rotate_around_point(basis.x.normalized(), rot_x * delta * fall_rotation_speed, mass_center.global_position)
	rotate_around_point(basis.z.normalized(), rot_z * delta * fall_rotation_speed, mass_center.global_position)

func get_floor_normal():
	return floor_ray.get_collision_normal()
