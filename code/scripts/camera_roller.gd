extends Camera3D

@export var roller : Node3D
@onready var raycast = $raycast
var camera_lerp = 2
var distance = 3
var height = 1
func _process(delta):
	var roller_velocity = roller.get_velocity()
	var lerp_direction = lerp(forward(), roller_velocity, delta * camera_lerp)
	var lerp_axis = lerp(quaternion * Vector3.UP, roller.quaternion * Vector3.UP, delta * camera_lerp)
	var slide_lerp_direction = lerp_direction.slide(lerp_axis.normalized())
	var local_pos = -slide_lerp_direction * distance + lerp_axis * height
	var global_pos = roller.global_position + local_pos
	var look_point = roller.global_position + Vector3.UP * height
	
	
	if roller_velocity.length() > 0.01:
		var pre_check_vector = quaternion * Vector3.FORWARD * 0.3
		var ray_vector = global_pos - look_point - pre_check_vector
		raycast.global_position = look_point
		raycast.target_position = quaternion.inverse() * ray_vector
		if raycast.is_colliding():
			var collision_point = raycast.get_collision_point() + pre_check_vector
			var final_pos = look_point + ray_vector.normalized() * lerp(look_point.distance_to(global_position), look_point.distance_to(collision_point), delta * 20)
			global_position = final_pos
		else: global_position = global_pos
		look_at_direction(slide_lerp_direction, lerp_axis)

func forward() -> Vector3:
	return quaternion * Vector3.FORWARD
	
func look_at_direction(direction : Vector3, axis : Vector3):
	if direction.length() > 0.01:
		look_at(global_position + direction, axis)
