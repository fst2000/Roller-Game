extends Node3D

@onready var rays = get_children()
func get_collision_point():
	var point := Vector3.ZERO
	var collisions_count = 0
	for r in rays:
		if r.is_colliding():
			collisions_count += 1
			point += r.get_collision_point()
	if collisions_count != 0:
		point /= collisions_count
	return point
	
func get_collision_normal():
	var normal := Vector3.ZERO
	var collisions_count = 0
	for r in rays:
		if r.is_colliding():
			collisions_count += 1
			normal += r.get_collision_normal()
	if collisions_count != 0:
		normal /= collisions_count
	return normal

func is_colliding():
	var is_colliding = false
	for r in rays:
		if r.is_colliding():
			var normal_dot = r.get_collision_normal().dot(r.get_collision_point().direction_to(r.global_position))
			if normal_dot > 0.1:
				is_colliding = true
	return is_colliding

func get_ray_length():
	return rays[0].target_position.length()