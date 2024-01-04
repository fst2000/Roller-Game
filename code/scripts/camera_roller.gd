extends Camera3D

@export var roller : Roller

var camera_lerp = 2
var distance = 3
var height = 1

func _process(delta):
	var roller_velocity = roller.get_velocity()
	var lerp_direction = lerp(forward(), roller_velocity, delta * camera_lerp)
	var lerp_axis = lerp(quaternion * Vector3.UP, roller.quaternion * Vector3.UP, delta * camera_lerp)
	var local_pos = -lerp_direction * distance + lerp_axis * height
	if roller_velocity.length() > 0.01:
		global_position = roller.global_position + local_pos
		look_at_direction(lerp_direction, lerp_axis)

func forward() -> Vector3:
	return quaternion * Vector3.FORWARD
	
func look_at_direction(direction : Vector3, axis : Vector3):
	look_at(global_position + direction, axis)
