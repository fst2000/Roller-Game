class_name Roller extends RigidBody3D

@onready var floor_ray = $FloorRay

var gravity = 10
var max_floor_angle := 60.0
var move_speed = 20
var rotation_speed = 3
var side_friction = 3
var input = KeyInput.new()

func _physics_process(delta):
	if floor_check():
		var forward = quaternion * Vector3.BACK
		var right = quaternion * Vector3.RIGHT
		var normal = floor_ray.get_collision_normal()
		var normal_lerp = lerp(quaternion * Vector3.UP, normal, delta * 10)
		var look_dir = (right).cross(normal_lerp)
		look_at(global_position - look_dir, normal_lerp)
		var move_force = look_dir * input.input().z * move_speed
		move_force.y = 0
		if linear_velocity.length() > move_speed: move_force = Vector3.ZERO
		
		var friction_force = -right * linear_velocity.dot(right) * side_friction
		var sticking_force = -normal_lerp * 0.5
		
		
		constant_force = move_force + friction_force + sticking_force
	else:
		constant_force = Vector3.ZERO
		rotate_object_local(Vector3.RIGHT, input.input().z * delta * rotation_speed)
	
	rotate_object_local(Vector3.UP, input.input().x * delta * rotation_speed)

func floor_check():
	var floor_angle = floor_ray.get_collision_normal().angle_to(quaternion * Vector3.UP) * 180 / PI
	return floor_ray.is_colliding() && floor_angle < max_floor_angle
	
func get_velocity() -> Vector3:
	return linear_velocity
