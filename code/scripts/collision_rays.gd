extends Node

@onready var multi_rays := get_children(false)

func get_colliding_rays():
	var colliding_multi_rays : Array
	for r in multi_rays:
		if r.is_colliding():
			colliding_multi_rays.append(r)
	return colliding_multi_rays

func force_raycast_update():
	for r in multi_rays:
		r.force_raycast_update()
