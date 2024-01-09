class_name CrashFloorState

var roller
var anim_tree
var time = 0.0
func _init(roller, ray):
	self.roller = roller
	self.anim_tree = roller.anim_tree
	var normal = ray.get_collision_normal()
	var point = ray.get_collision_point()
	var forward_back_blend = round(-roller.forward().dot(normal))
	roller.global_position = point + normal
	roller.set_axis(normal)
	anim_tree.set_condition("is_crash_start", true)
	anim_tree.set_condition("is_crash_end", false)
	anim_tree.set_blend2("crash/up_floor_low_blend", 0)
	anim_tree.set_blend2("crash/floor_forward_back_blend", forward_back_blend)
	
func update(delta):
	time += delta
	if roller.floor_check():
		roller.slide(delta)
		var friction = 2.0
		roller.velocity *= 1 - (friction * delta)
	else:
		roller.fall(delta)
	roller.collide()

func exit():
	anim_tree.set_condition("is_crash_start", false)
	anim_tree.set_condition("is_crash_end", true)

func next_state():
	if time > 1.0:
		if roller.floor_check():
			return RaceState.new(roller)
		else:
			return FallState.new(roller)
	return self
