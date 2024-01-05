class_name FallState

var roller

func _init(roller):
	self.roller = roller
	roller.anim_tree["parameters/conditions/is_falling"] = true
	roller.anim_tree["parameters/conditions/is_on_floor"] = false
	
func update(delta):
	print("fall")
	roller.fall(delta)

func next_state():
	if roller.floor_check():
		return LandState.new(roller)
	return self

func exit():
	roller.anim_tree["parameters/conditions/is_falling"] = false
	roller.anim_tree["parameters/conditions/is_on_floor"] = true
