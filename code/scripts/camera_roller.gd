extends Camera3D

@export var roller : Node3D
@onready var raycast = $raycast
@onready var camera_pivot = roller.get_node("camera_pivot")
var camera_lerp = 2
var distance = 2
func _process(delta):
	var roller_velocity = roller.get_velocity()
	var lerp_direction = lerp(forward(), roller_velocity, delta * camera_lerp)
	var axis
	if roller.floor_check(): axis = roller.get_floor_normal()
	else: axis = Vector3.UP 
	var lerp_axis = lerp(basis.y, axis, delta * camera_lerp)
	
	var global_pos = -lerp_direction * distance + camera_pivot.global_position
	var look_point = camera_pivot.global_position
	
	if roller_velocity.length() > 0.01:
		if raycast.is_colliding():
			var pre_check_vector = quaternion * Vector3.FORWARD * 0.5
			var ray_vector = global_pos - look_point - pre_check_vector
			raycast.global_position = look_point
			raycast.target_position = quaternion.inverse() * ray_vector
			var collision_point = raycast.get_collision_point() + pre_check_vector
			var final_pos = look_point + ray_vector.normalized() * look_point.distance_to(collision_point)
			global_position = final_pos
		else: global_position = global_pos
		look_at_direction(lerp_direction, lerp_axis)
		rotation_degrees.z = clamp(rotation_degrees.z, -90, 90)

func forward() -> Vector3:
	return quaternion * Vector3.FORWARD
	
func look_at_direction(direction : Vector3, axis : Vector3):
	if direction.length() > 0.01:
		look_at(global_position + direction, axis)
