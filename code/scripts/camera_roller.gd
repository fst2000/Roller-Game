extends Camera3D

@export var roller : Node3D
@onready var raycast = $raycast
@onready var camera_pivot = roller.get_node("camera_pivot")
var camera_lerp = 5
var distance_min = 2.0
var distance_max = 3.5

func _process(delta):
	var velocity = roller.get_velocity()
	var distance = clamp(distance_min + velocity.length() * 0.05, distance_min, distance_max)
	var axis = basis.x.cross(velocity).normalized()
	if roller.floor_check(): axis = roller.get_floor_normal()
	axis.y = abs(axis.y)
	var lerp_axis = lerp(basis.y, axis, delta * camera_lerp)
	var look_point = camera_pivot.global_position
	var direction = forward()
	if velocity.length() > 0.1: direction = lerp(forward(), velocity.slide(axis).normalized(), camera_lerp * delta)
	var global_pos = camera_pivot.global_position - direction * distance
	if raycast.is_colliding():
		var pre_check_vector = quaternion * Vector3.FORWARD * 0.5
		var ray_vector = global_pos - look_point - pre_check_vector
		raycast.global_position = look_point
		raycast.target_position = quaternion.inverse() * ray_vector
		var collision_point = raycast.get_collision_point() + pre_check_vector
		var final_pos = look_point + ray_vector.normalized() * look_point.distance_to(collision_point)
		global_pos = final_pos
	global_position = global_pos
	look_at_direction(direction, lerp_axis)
	rotation_degrees.z = clamp(rotation_degrees.z, -90, 90)

func forward() -> Vector3:
	return quaternion * Vector3.FORWARD
	
func look_at_direction(direction : Vector3, axis : Vector3):
	if direction.length() > 0.01:
		look_at(global_position + direction, axis)
