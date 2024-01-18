class_name CrashWallState

var roller
var anim_tree
var time = 0.0

func _init(roller, ray):
	self.roller = roller
	self.anim_tree = roller.anim_tree
	var normal = ray.get_collision_normal()
	var bounce = 0.3
	roller.velocity = roller.velocity.dot(-normal) * normal * bounce
	var forward_back_blend = round(-roller.forward().dot(normal))
	anim_tree.set_condition("is_crash_start", true)
	anim_tree.set_condition("is_crash_end", false)
	anim_tree.set_blend2("crash/floor_wall_blend", 1)
	anim_tree.set_blend2("crash/wall_forward_back_blend", forward_back_blend)

func update(delta):
	time += delta
	roller.collide()
	if roller.floor_check():
		roller.slide(delta)
		var friction = 2.0
		roller.velocity *= 1 - (friction * delta)
	else:
		roller.fall(delta)
	
func exit():
	anim_tree.set_condition("is_crash_start", false)
	anim_tree.set_condition("is_crash_end", true)

func next_state():
	if time > 0.2:
		return FallState.new(roller)
	return self
