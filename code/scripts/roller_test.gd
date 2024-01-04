extends Node3D

@onready var shape = $shapecast
@onready var ray = $floor_ray
var gravity = 10
var jump_force = 5
var move_speed = 15
var rotation_speed = 5
var side_friction = 5
var velocity := Vector3.ZERO
var roller_input := KeyInput.new()
func get_velocity() -> Vector3:
	return velocity

func _physics_process(delta):
	if ray.is_colliding():
		race(delta)
	else:
		fall(delta)
	
func move(velocity : Vector3):
	global_position += velocity 

func look_at_direction(direction : Vector3, axis : Vector3):
	look_at(global_position + direction, axis)

func forward() -> Vector3:
	return quaternion * Vector3.FORWARD

func fall(delta):
	var input = roller_input.input()
	velocity.y -= gravity * delta
	move(velocity * delta)
	rotate(quaternion * Vector3.UP, input.x * delta * rotation_speed)

func race(delta):
	var input = roller_input.input()
	var right = quaternion * Vector3.RIGHT
	var point = ray.get_collision_point()
	global_position = point
	var normal = ray.get_collision_normal()
	var axis_lerp = lerp(quaternion * Vector3.UP, normal, delta * 10)
	var floor_forward = axis_lerp.cross(right)
	look_at_direction(floor_forward, axis_lerp)
	
	var slope_velocity = (Vector3.DOWN * gravity).slide(normal) * delta
	velocity = velocity.slide(normal) + slope_velocity
	if velocity.length() < move_speed:
		var move_velocity = forward().slide(Vector3.UP) * move_speed * -input.z * delta
		velocity += move_velocity
	var side_friction_velocity = -right * right.dot(velocity) * delta * side_friction
	velocity += side_friction_velocity
	move((velocity) * delta)
	rotate(quaternion * Vector3.UP, input.x * delta * rotation_speed)

func collide():
	pass
