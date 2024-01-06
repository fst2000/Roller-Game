class_name IdleState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_tree.set_condition("is_idle", true)
	
func update(delta):
	roller.velocity.x = 0
	roller.velocity.z = 0

func next_state():
	if roller.floor_check():
		if roller.roller_input.input().z > 0.1:
			return RaceState.new(roller)
	else:
		return FallState.new(roller)
	return self

func exit():
	roller.anim_tree["parameters/conditions/is_idle"] = false
