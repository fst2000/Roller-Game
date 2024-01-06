extends RayCast3D

var ray_offset = Vector3.UP
@onready var ray_position_mesh = $ray_position
@onready var ray_prev_position_mesh = $ray_positionprev
@onready var roller = get_parent()
@onready var prev_position = roller.global_position + Vector3.UP

func _physics_process(delta):
	ray_offset = roller.quaternion * Vector3.UP
	var curr_position = roller.global_position + ray_offset
	global_position = prev_position
	target_position = curr_position - prev_position
	
	ray_position_mesh.global_position = curr_position
	ray_prev_position_mesh.global_position = prev_position
	
	prev_position = curr_position
