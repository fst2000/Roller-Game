class_name AccelerateBackState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_player.play("accelerate_back")

func update(delta): pass

func exit(): pass

func next_state():
	var forward_acceleration = roller.roller_input.acceleration().z
	if forward_acceleration < 0: return AccelerateBackState.new(roller)
	if forward_acceleration == 0: return RaceIdleState.new(roller)
	return self
