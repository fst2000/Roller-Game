class_name JumpState

var roller
var time = 0.0

func _init(roller):
	self.roller = roller
	roller.anim_tree.set_condition("is_jump", true)
	roller.anim_tree.set_condition("is_not_jump", false)
	roller.jump()
	
func update(delta):
	roller.fall(delta)
	roller.flip(delta)
	time += delta

func next_state():
	
	if time > 0.25:
		return FallState.new(roller)
	
	if roller.floor_check():
		return LandState.new(roller)
	return self

func exit():
	roller.anim_tree.set_condition("is_jump", false)
	roller.anim_tree.set_condition("is_not_jump", true)
