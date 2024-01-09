class_name LandState

var roller
var time = 0.0

func _init(roller):
	self.roller = roller
	roller.anim_tree.set_condition("is_falling", false)
	roller.anim_tree.set_condition("is_on_floor", true)
	
func update(delta):
	roller.race(delta)
	roller.collide()
	time += delta

func next_state():
	if time > 0.25:
		return RaceState.new(roller) 

	if !roller.floor_check():
		return FallState.new(roller)
	return self

func exit():
	pass
