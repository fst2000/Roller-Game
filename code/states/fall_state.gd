class_name FallState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_tree.set_condition("is_falling", true)
	roller.anim_tree.set_condition("is_on_floor", false)
	
func update(delta):
	roller.fall(delta)
	roller.flip(delta)

func next_state():
	if roller.floor_check():
		return LandState.new(roller)

	var colliding_rays = roller.collision_rays.get_colliding_rays()
	if colliding_rays:
		var ray = colliding_rays.front()
		return CrashFloorState.new(roller, ray)
	
	return self

func exit():
	roller.anim_tree.set_condition("is_falling", false)
	roller.anim_tree.set_condition("is_on_floor", true)
