class_name CrashFloorBackState

var roller
var anim_tree
var time = 0.0
func _init(roller):
	self.roller = roller
	self.anim_tree = roller.anim_tree
	anim_tree.set_condition("is_crash_start", true)
	anim_tree.set_condition("is_crash_end", false)
	anim_tree.set_blend2("crash/up_floor_low_blend", 0)
	anim_tree.set_blend2("crash/floor_forward_back_blend", 1)
	
func update(delta):
	time += delta
	if roller.floor_check():
		roller.slide(delta)
		var friction = 2.0
		roller.velocity *= 1 - (friction * delta)
	
func exit():
	anim_tree.set_condition("is_crash_start", false)
	anim_tree.set_condition("is_crash_end", true)

func next_state():
	if time > 1.0:
		return RaceState.new(roller)
	
	return self
