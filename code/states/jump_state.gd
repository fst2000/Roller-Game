class_name JumpState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_tree.set_condition("is_jump", true)
	roller.anim_tree.set_condition("is_not_jump", false)
	roller.jump()
	
func update(delta):
	roller.fall(delta)

func next_state():
	if roller.floor_check():
		exit()
		return FallState.new(roller)
	return self

func exit():
	roller.anim_tree.set_condition("is_jump", false)
	roller.anim_tree.set_condition("is_not_jump", true)
